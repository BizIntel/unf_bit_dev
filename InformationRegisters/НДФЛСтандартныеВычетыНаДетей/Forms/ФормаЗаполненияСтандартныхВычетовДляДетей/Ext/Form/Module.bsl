﻿

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Сотрудник = Параметры.Сотрудник;
	
	ЗаполнитьДанныеПоВычету();
	Элементы.ГруппаСтраницаСДанными.Видимость = Истина;
	Элементы.ГруппаСтраницаПустая.Видимость = Ложь;
	
	Если ТаблицаВычетовНаДетей.Количество() = 0 Тогда
		НоваяСтрока = ТаблицаВычетовНаДетей.Добавить();
		НоваяСтрока.Номер = ТаблицаВычетовНаДетей.Количество();
		НоваяСтрока.КодВычета = КодВычетаПоНомеруСтроки(НоваяСтрока.Номер);
		НоваяСтрока.НоваяЗапись = Истина;
		НоваяСтрока.НаименованиеВычета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НоваяСтрока.КодВычета, "Наименование");
	КонецЕсли;
	
	СправочникКодовВычетов = Справочники.ВычетыНДФЛ;
	
	// Добавляем необходимые кода вычетов
	СписокКодовВычета = Элементы.ТаблицаВычетовНаДетейКодВычета.СписокВыбора;
	СответствиеКодов = Новый Соответствие;
	
	Для Код = 108 По 125 Цикл
		Попытка
			ЭлементСправочника = ПредопределенноеЗначение("Справочник.ВычетыНДФЛ.Код"+Код);
		Исключение
			Продолжить;
		КонецПопытки;
		КодИНаименование = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЭлементСправочника, "Наименование, Код");
		СписокКодовВычета.Добавить(ЭлементСправочника,
			Нстр("ru='Код '")+Код
			+", "+Формат(РазмерВычетов.Получить(ЭлементСправочника),"ЧЦ=10; ЧДЦ=0; ЧРГ=' '; ЧН=0")+ " руб. ");
		СответствиеКодов.Вставить(ЭлементСправочника, Код);
	КонецЦикла;
	КодыВычетов = Новый ФиксированноеСоответствие(СответствиеКодов);
	СуммаНаДату = НСтр("ru='текущую дату'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Вычеты по НДФЛ на детей (Итого: %1)'"),
		Формат(ТаблицаВычетовНаДетей.Итог("СуммаВычета"),"ЧЦ=10; ЧДЦ=0; ЧРГ=' '; ЧН=0")+ " руб.");
	
	ФормаОткрывается = Истина;
	СтрокаУдалена = Ложь;
	
КонецПроцедуры


&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Модифицированность И НЕ БылиНажатыКнопкиЗакрытия Тогда
		
		спсОтветов = Новый СписокЗначений;
		спсОтветов.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Сохранить'"));
		спсОтветов.Добавить(КодВозвратаДиалога.Нет, НСтр("ru='Нет'"));
		спсОтветов.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru='Отмена'"));
		
		оп = Новый ОписаниеОповещения("ОповещениеПриЗакрытии", ЭтотОбъект);
		
		ТекстВопроса = НСтр("ru = 'Даные были изменены. Сохранить изменения?'");
		ПоказатьВопрос(оп, ТекстВопроса, спсОтветов);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеПриЗакрытии(Ответ, Параметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ЗаписатьИЗакрыть();
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		БылиНажатыКнопкиЗакрытия = Ложь;
		Модифицированность = Ложь; 
		Закрыть();
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда
		БылиНажатыКнопкиЗакрытия = Ложь;
	КонецЕсли;
	
КонецПроцедуры


/////////////////////////////////////////////////////////////////////////////////
// СОБЫТИЯ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ ФОРМЫ


&НаКлиенте
Процедура ЗаписатьИЗакрыть()
	
	Если Модифицированность Тогда
		// Записываем данные в таблицу по текущей строке
		ТекДанные = Элементы.ТаблицаВычетовНаДетей.ТекущиеДанные;
		Если Текданные<> Неопределено Тогда
			Строка = ТаблицаВычетовНаДетей.НайтиПоИдентификатору(ИдентификаторРедактируемойСтроки);
			Строка.СуммаВычета = РазмерВычетов.Получить(ТекДанные.КодВычета);
		КонецЕсли;
		
		ОписаниеОшибок = "";
		Если Не ВыполнитьПроверку(ОписаниеОшибок) Тогда
			Для Каждого Ошибка Из ОписаниеОшибок Цикл
				ПолеИОписаниеОшибки =  Ошибка.Значение;
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ПолеИОписаниеОшибки.Описание,, ПолеИОписаниеОшибки.Поле);
			КонецЦикла;
			Возврат;
		КонецЕсли;
		
		СохранитьДанные();
		Оповестить("ИзменилисьВычетыНаДетейПоСотруднику", Сотрудник);
		Модифицированность = ЛожЬ;
	КонецЕсли;
	
	БылиНажатыКнопкиЗакрытия = Истина;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	БылиНажатыКнопкиЗакрытия = Истина;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаРожденияРебенкаПриИзменении(Элемент)
	
	ТекДанные = Элементы.ТаблицаВычетовНаДетей.ТекущиеДанные;
	ЗаполнитьДатуЗавершенияВычета();
	ТаблицаВычетовНаДетей.Сортировать("ДатаРожденияРебенка");
	ТекущийНомерСтроки = ТекДанные.Номер;
	НомерСтроки = 1;
	Для Каждого Строка Из ТаблицаВычетовНаДетей Цикл
		Строка.Номер = НомерСтроки;
		НомерСтроки = НомерСтроки+1;
	КонецЦикла;
	СтрокаВТаблице = ТаблицаВычетовНаДетей.НайтиПоИдентификатору(ИдентификаторРедактируемойСтроки);
	Если СтрокаВТаблице.Номер <> ТекущийНомерСтроки Тогда
		// Изменился порядок строк
		СпсОтветов = Новый СписокЗначений;
		СпсОтветов.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Скорректировать'"));
		СпсОтветов.Добавить(КодВозвратаДиалога.Нет, НСтр("ru='Оставить как есть'"));
		
		оп = Новый ОписаниеОповещения("ОповещениеКорректировкиКодовВычетов", ЭтотОбъект);
		
		ПоказатьВопрос(оп, НСтр("ru='В таблице изменился порядок строк.
					|Скорректировать кода вычетов в строках согласно новому порядку?'"), СпсОтветов);
		Возврат;
	КонецЕсли;
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеКорректировкиКодовВычетов(Ответ, Параметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ЗаполнитьКодаВычетаВТаблице();
	КонецЕсли;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЗаписьСРебенком(Команда)
	
	НоваяСтрока = ТаблицаВычетовНаДетей.Добавить();
	НоваяСтрока.Номер = ТаблицаВычетовНаДетей.Количество();
	КодИНаименование = НаименованиеИКодВычетаПоНомеруСтроки(НоваяСтрока.Номер);
	НоваяСтрока.КодВычета = КодИНаименование.Код;
	НоваяСтрока.НоваяЗапись = Истина;
	НоваяСтрока.НаименованиеВычета = КодИНаименование.Наименование;
	Если Элементы.ГруппаСтраницаПустая.Видимость Тогда
		Элементы.ГруппаСтраницаСДанными.Видимость = Истина;
		Элементы.ГруппаСтраницаПустая.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ТаблицаВычетовНаДетей.ТекущаяСтрока =НоваяСтрока.ПолучитьИдентификатор();
	Модифицированность = Истина;
	
КонецПроцедуры


&НаКлиенте
Процедура УдалитьЗаписьСРебенком(Команда)
	
	ТекДанные = Элементы.ТаблицаВычетовНаДетей.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	// Если строка последняя или больше второй, то не корректируем кода вычетов
	НомерСтроки = ТекДанные.Номер;
	СпрашиватьОКорректировке = Не ((НомерСтроки = ТаблицаВычетовНаДетей.Количество()) ИЛИ (НомерСтроки >2));
	
	ТаблицаВычетовНаДетей.Удалить(ТекДанные);
	СтрокаУдалена = Истина;
	Модифицированность = Истина;
	
	Если ТаблицаВычетовНаДетей.Количество()= 0
		И Элементы.ГруппаСтраницаСДанными.Видимость Тогда
		Элементы.ГруппаСтраницаСДанными.Видимость = Ложь;
		Элементы.ГруппаСтраницаПустая.Видимость = Истина;
	Иначе
		
		НомерСтроки = 1;
		Для Каждого Строка Из ТаблицаВычетовНаДетей Цикл
			Строка.Номер = НомерСтроки;
			НомерСтроки = НомерСтроки+1;
		КонецЦикла;
		Если СпрашиватьОКорректировке Тогда
			СпсОтветов = Новый СписокЗначений;
			СпсОтветов.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Скорректировать'"));
			СпсОтветов.Добавить(КодВозвратаДиалога.Нет, НСтр("ru='Оставить как есть'"));
			
			оп = Новый ОписаниеОповещения("ОповещениеКорректировкиКодовВычетов", ЭтотОбъект);
			
			ПоказатьВопрос(оп, НСтр("ru='В таблице изменился порядок строк.
					|Скорректировать кода вычетов в строках согласно новому порядку?'"), СпсОтветов);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаВычетовНаДетейПриАктивизацииСтроки(Элемент)
	
	ТекДанные = Элементы.ТаблицаВычетовНаДетей.ТекущиеДанные;
	Если Текданные<> Неопределено Тогда
		// Сохраняем данные по ребенку 
		//
		Если ФормаОткрывается ИЛИ СтрокаУдалена Тогда
			ФормаОткрывается = Ложь;
			СтрокаУдалена = Ложь;
		Иначе
			
			Если ИдентификаторРедактируемойСтроки = Элементы.ТаблицаВычетовНаДетей.ТекущаяСтрока Тогда
				Возврат;
			КонецЕсли;
			
			Строка = ТаблицаВычетовНаДетей.НайтиПоИдентификатору(ИдентификаторРедактируемойСтроки);
			Строка.СуммаВычета = РазмерВычетов.Получить(Строка.КодВычета);
			Строка.Представление = ?(ЗначениеЗаполнено(Строка.КодВычета), Нстр("ru='Код '")+СокрЛП(Строка.КодВычета), "")
			+?(Строка.СуммаВычета> 0 , ", "+Формат(Строка.СуммаВычета,"ЧЦ=10; ЧДЦ=0; ЧРГ=' '; ЧН=0")+ " руб. ", "");
			Строка.НоваяЗапись = Ложь;
		КонецЕсли;
		// Отображаем данные по текущему ребенку
		//
		УстановитьПереключателиПоКодуВычета();
		Студент = (Текданные.ПериодЗавершения = ДобавитьМесяц(Текданные.ДатаРожденияРебенка, 12*24));
		ИдентификаторРедактируемойСтроки = Элементы.ТаблицаВычетовНаДетей.ТекущаяСтрока;
		ЗаполнитьДатуЗавершенияВычета();
	Иначе
		ФормаОткрывается = Ложь;
		
	КонецЕсли;
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Вычеты по НДФЛ на детей (Итого: %1)'"),
		Формат(ТаблицаВычетовНаДетей.Итог("СуммаВычета"),"ЧЦ=10; ЧДЦ=0; ЧРГ=' '; ЧН=0")+ " руб.");
	
КонецПроцедуры


&НаКлиенте
Процедура КодВычетаПриИзменении(Элемент)
	
	ТекДанные = Элементы.ТаблицаВычетовНаДетей.ТекущиеДанные;
	Описание = "";
	
	ТекДанные.НаименованиеВычета = ПолучитьНаименованиеКодаВычета(ТекДанные.КодВычета);
	Если ПустаяСтрока(ТекДанные.НаименованиеВычета) Тогда
		ТекДанные.НаименованиеВычета = Нстр("ru ='<<Вычет не выбран>>'");
	КонецЕсли;
	
	УстановитьПереключателиПоКодуВычета();
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СтудентПриИзменении(Элемент)
	
	ЗаполнитьДатуЗавершенияВычета();
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтказОтВычетаВторогоРодителяПриИзменении(Элемент)
	
	Если ОтказОтВычетаВторогоРодителя Тогда
		ЕдинственныйРодитель = Ложь;
	КонецЕсли;
	КодВычетаИНаименование = КодВычетаПоПереключателям();
	ТекДанные = Элементы.ТаблицаВычетовНаДетей.ТекущиеДанные;
	ТекДанные.КодВычета = КодВычетаИНаименование.КодВычета;
	ТекДанные.НаименованиеВычета = КодВычетаИНаименование.НаименованиеВычета;
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЕдинственныйРодительПриИзменении(Элемент)
	
	Если ЕдинственныйРодитель Тогда
		ОтказОтВычетаВторогоРодителя = Ложь;
	КонецЕсли;
	КодВычетаИНаименование = КодВычетаПоПереключателям();
	ТекДанные = Элементы.ТаблицаВычетовНаДетей.ТекущиеДанные;
	ТекДанные.КодВычета = КодВычетаИНаименование.КодВычета;
	ТекДанные.НаименованиеВычета = КодВычетаИНаименование.НаименованиеВычета;
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТретийРебенокПриИзменении(Элемент)
	
	КодВычетаИНаименование = КодВычетаПоПереключателям();
	ТекДанные = Элементы.ТаблицаВычетовНаДетей.ТекущиеДанные;
	ТекДанные.КодВычета = КодВычетаИНаименование.КодВычета;
	ТекДанные.НаименованиеВычета = КодВычетаИНаименование.НаименованиеВычета;
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ИнвалидIИлиIIГруппыПриИзменении(Элемент)
	
	КодВычетаИНаименование = КодВычетаПоПереключателям();
	ТекДанные = Элементы.ТаблицаВычетовНаДетей.ТекущиеДанные;
	ТекДанные.КодВычета = КодВычетаИНаименование.КодВычета;
	ТекДанные.НаименованиеВычета = КодВычетаИНаименование.НаименованиеВычета;
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаВычетовНаДетейПериодПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаНаДатуНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если СуммаНаДату = НСтр("ru='текущую дату'") Тогда
		АктуальнаяДата = ТекущаяДата();
	Иначе
		АктуальнаяДата = СуммаНаДату;
	КонецЕсли;
	
	оп = Новый ОписаниеОповещения("ОповещениеВыбораДаты", ЭтотОбъект);
	
	ПоказатьВводДаты(оп,АктуальнаяДата, НСтр("ru = 'Выберите дату для расчета суммы вычета'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеВыбораДаты(Результат, Параметры) Экспорт
	Если НЕ ЗначениеЗаполнено(Результат) Тогда
		Возврат;
	КонецЕсли;
	
	ОпределитьРазмерыВычетовНаДату(Результат);
	Если Результат = НачалоДня(ТекущаяДата()) Тогда
		СуммаНаДату = НСтр("ru='текущую дату'");
	Иначе
		СуммаНаДату = Результат;
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ И ПРОЦЕДУРЫ

// Процедура сохраняет запись в регистр сведений ДокументыФизическихЛиц
&НаСервере
Процедура СохранитьДанные()
	
	НаборЗаписей = РегистрыСведений.НДФЛСтандартныеВычетыНаДетей.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Сотрудник.Установить(Сотрудник);
	
	Для Каждого СтрокаВычета Из ТаблицаВычетовНаДетей Цикл
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Период              = СтрокаВычета.Период;
		НоваяЗапись.Сотрудник           = Сотрудник;
		НоваяЗапись.КодВычета           = СтрокаВычета.КодВычета;
		НоваяЗапись.ДатаРожденияРебенка = СтрокаВычета.ДатаРожденияРебенка;
		НоваяЗапись.НомерСтрокиСРебенком = СтрокаВычета.Номер;
		НоваяЗапись.ПериодЗавершения    = СтрокаВычета.ПериодЗавершения;
	КонецЦикла;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры




&НаСервере
Процедура ЗаполнитьДанныеПоВычету()
	
	// Формируем пакет запроса
	ЗапросПоВычетуНаДетей = Новый Запрос;
	ЗапросПоВычетуНаДетей.Текст =
	"ВЫБРАТЬ
	|	НДФЛРазмерВычетовСрезПоследних.КодВычета,
	|	НДФЛРазмерВычетовСрезПоследних.Размер
	|ПОМЕСТИТЬ РазмерВычетов
	|ИЗ
	|	РегистрСведений.НДФЛРазмерВычетов.СрезПоследних КАК НДФЛРазмерВычетовСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ 
	|	НДФЛСтандартныеВычетыНаДетейСрезПоследних.Период,
	|	НДФЛСтандартныеВычетыНаДетейСрезПоследних.ДатаРожденияРебенка,
	|	НДФЛСтандартныеВычетыНаДетейСрезПоследних.КодВычета,
	|	НДФЛСтандартныеВычетыНаДетейСрезПоследних.КодВычета.Наименование КАК НаименованиеВычета,
	|	НДФЛСтандартныеВычетыНаДетейСрезПоследних.НомерСтрокиСРебенком КАК Номер,
	|	НДФЛСтандартныеВычетыНаДетейСрезПоследних.ПериодЗавершения,
	|	РазмерВычетов.Размер КАК СуммаВычета
	|ИЗ
	|	РегистрСведений.НДФЛСтандартныеВычетыНаДетей.СрезПоследних КАК НДФЛСтандартныеВычетыНаДетейСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ РазмерВычетов КАК РазмерВычетов
	|		ПО (РазмерВычетов.КодВычета = НДФЛСтандартныеВычетыНаДетейСрезПоследних.КодВычета)
	|ГДЕ
	|	НДФЛСтандартныеВычетыНаДетейСрезПоследних.Сотрудник = &Сотрудник;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РазмерВычетов.КодВычета,
	|	РазмерВычетов.Размер
	|ИЗ
	|	РазмерВычетов КАК РазмерВычетов";
	ЗапросПоВычетуНаДетей.УстановитьПараметр("Сотрудник", Сотрудник);
	ПакетЗапроса = ЗапросПоВычетуНаДетей.ВыполнитьПакет();
	ВычетыНаДетей = ПакетЗапроса[1].Выгрузить();
	ТаблицаВычетовНаДетей.Загрузить(ВычетыНаДетей);
	ТаблицаВычетовНаДетей.Сортировать("ДатаРожденияРебенка");
	НомерСтроки = 1;
	Для Каждого Строка Из ТаблицаВычетовНаДетей Цикл
		Строка.Номер = НомерСтроки;
		НомерСтроки = НомерСтроки +1;
		Если ПустаяСтрока(Строка.НаименованиеВычета) Тогда
			Строка.НаименованиеВычета = Нстр("ru ='<<Вычет не выбран>>'");
		КонецЕсли;
		Строка.Представление = ?(ЗначениеЗаполнено(Строка.КодВычета), Нстр("ru='Код '")+СОКРЛП(Строка.КодВычета), "")
			+?(Строка.СуммаВычета> 0 , ", "+Формат(Строка.СуммаВычета,"ЧЦ=10; ЧДЦ=0; ЧРГ=' '; ЧН=0")+ " руб. ", "");
	КонецЦикла;
	ВыборкаРазмеровВычетов = ПакетЗапроса[2].Выбрать();
	СоответствиеВычетов = Новый Соответствие;
	
	Пока ВыборкаРазмеровВычетов.Следующий() Цикл
		СоответствиеВычетов.Вставить(ВыборкаРазмеровВычетов.КодВычета, ВыборкаРазмеровВычетов.Размер);
	КонецЦикла;
	РазмерВычетов = Новый ФиксированноеСоответствие(СоответствиеВычетов);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДатуЗавершенияВычета()
	
	ТекДанные = Элементы.ТаблицаВычетовНаДетей.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекДанные.ДатаРожденияРебенка) Тогда
		Если Студент Тогда
			ДатаЗавершенияВычета = ДобавитьМесяц(ТекДанные.ДатаРожденияРебенка, 12*24);
		Иначе
			ДатаЗавершенияВычета = ДобавитьМесяц(ТекДанные.ДатаРожденияРебенка, 12*18);
		КонецЕсли;
	Иначе
		ДатаЗавершенияВычета = Дата(1,1,1);
	КонецЕсли;
	ТекДанные.ПериодЗавершения = ДатаЗавершенияВычета;
	
КонецПроцедуры


&НаСервере
Функция ВыполнитьПроверку(ОписаниеОшибок)
	
	ОписаниеОшибок = Новый Структура;
	НомерСтроки = 1;
	Для Каждого Строка Из ТаблицаВычетовНаДетей Цикл
		ТекстОшибки = ?(ЗначениеЗаполнено(Строка.Период),"", НСтр("ru ='Дата заявления;'"))
			+ ?(ЗначениеЗаполнено(Строка.ДатаРожденияРебенка),"", НСтр("ru ='Дата рождения ребенка;'"))
			+ ?(ЗначениеЗаполнено(Строка.КодВычета),"", НСтр("ru ='Код вычета;'"));
		Если ТекстОшибки <> "" Тогда
			ОписаниеОшибок.Вставить("Строка"+НомерСтроки,Новый Структура("Поле, Описание","ТаблицаВычетовНаДетей["+Строка(НомерСтроки-1)+"].ДатаРожденияРебенка",
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'В строке №%1 не заполнены следующие поля: '"), НомерСтроки) +
				ТекстОшибки));
		КонецЕсли;
		НомерСтроки = НомерСтроки+1;
	КонецЦикла;
	
	Если ОписаниеОшибок.Количество() = 0 Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура УстановитьПереключателиПоКодуВычета()
	
	Код = КодыВычетов.Получить(Элементы.ТаблицаВычетовНаДетей.ТекущиеДанные.КодВычета);
	Если Код = Неопределено Тогда
		ТретийРебенок                = Ложь;
		ОтказОтВычетаВторогоРодителя = Ложь;
		ЕдинственныйРодитель         = Ложь;
		ИмеетИнвалидность            = Ложь;
		Возврат;
	КонецЕсли;
	
	Если Код = 108 Тогда
		ТретийРебенок                = Ложь;
		ОтказОтВычетаВторогоРодителя = Ложь;
		ЕдинственныйРодитель         = Ложь;
		ИмеетИнвалидность            = Ложь;
	ИначеЕсли Код = 109 Тогда
		ТретийРебенок                = Ложь;
		ОтказОтВычетаВторогоРодителя = Ложь;
		ЕдинственныйРодитель         = Ложь;
		ИмеетИнвалидность            = Истина;
	ИначеЕсли Код = 110 Тогда
		ТретийРебенок                = Ложь;
		ОтказОтВычетаВторогоРодителя = Ложь;
		ЕдинственныйРодитель         = Истина;
		ИмеетИнвалидность            = Ложь;
	ИначеЕсли Код = 111 Тогда
		ТретийРебенок                = Ложь;
		ОтказОтВычетаВторогоРодителя = Истина;
		ЕдинственныйРодитель         = Ложь;
		ИмеетИнвалидность            = Ложь;
	ИначеЕсли Код = 112 Тогда
		ТретийРебенок                = Ложь;
		ОтказОтВычетаВторогоРодителя = Ложь;
		ЕдинственныйРодитель         = Истина;
		ИмеетИнвалидность            = Истина;
	ИначеЕсли Код = 113 Тогда
		ТретийРебенок                = Ложь;
		ОтказОтВычетаВторогоРодителя = Истина;
		ЕдинственныйРодитель         = Ложь;
		ИмеетИнвалидность            = Истина;
	ИначеЕсли Код = 114 Тогда
		ТретийРебенок                = Ложь;
		ОтказОтВычетаВторогоРодителя = Ложь;
		ЕдинственныйРодитель         = Ложь;
		ИмеетИнвалидность            = Ложь;
	ИначеЕсли Код = 115 Тогда
		ТретийРебенок                = Ложь;
		ОтказОтВычетаВторогоРодителя = Ложь;
		ЕдинственныйРодитель         = Ложь;
		ИмеетИнвалидность            = Ложь;
	ИначеЕсли Код = 116 Тогда
		ТретийРебенок                = Истина;
		ОтказОтВычетаВторогоРодителя = Ложь;
		ЕдинственныйРодитель         = Ложь;
		ИмеетИнвалидность            = Ложь;
	ИначеЕсли Код = 117 Тогда
		ТретийРебенок                = Ложь;
		ОтказОтВычетаВторогоРодителя = Ложь;
		ЕдинственныйРодитель         = Ложь;
		ИмеетИнвалидность            = Истина;
	ИначеЕсли Код = 118 Тогда
		ТретийРебенок                = Ложь;
		ОтказОтВычетаВторогоРодителя = Ложь;
		ЕдинственныйРодитель         = Истина;
		ИмеетИнвалидность            = Ложь;
	ИначеЕсли Код = 119 Тогда
		ТретийРебенок                = Ложь;
		ОтказОтВычетаВторогоРодителя = Ложь;
		ЕдинственныйРодитель         = Истина;
		ИмеетИнвалидность            = Ложь;
	ИначеЕсли Код = 120 Тогда
		ТретийРебенок                = Истина;
		ОтказОтВычетаВторогоРодителя = Ложь;
		ЕдинственныйРодитель         = Истина;
		ИмеетИнвалидность            = Ложь;
	ИначеЕсли Код = 121 Тогда
		ТретийРебенок                = Ложь;
		ОтказОтВычетаВторогоРодителя = Ложь;
		ЕдинственныйРодитель         = Истина;
		ИмеетИнвалидность            = Истина;
	ИначеЕсли Код = 122 Тогда
		ТретийРебенок                = Ложь;
		ОтказОтВычетаВторогоРодителя = Истина;
		ЕдинственныйРодитель         = Ложь;
		ИмеетИнвалидность            = Ложь;
	ИначеЕсли Код = 123 Тогда
		ТретийРебенок                = Ложь;
		ОтказОтВычетаВторогоРодителя = Истина;
		ЕдинственныйРодитель         = Ложь;
		ИмеетИнвалидность            = Ложь;
	ИначеЕсли Код = 124 Тогда
		ТретийРебенок                = Истина;
		ОтказОтВычетаВторогоРодителя = Истина;
		ЕдинственныйРодитель         = Ложь;
		ИмеетИнвалидность            = Ложь;
	ИначеЕсли Код = 125 Тогда
		ТретийРебенок                = Ложь;
		ОтказОтВычетаВторогоРодителя = Истина;
		ЕдинственныйРодитель         = Ложь;
		ИмеетИнвалидность            = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция КодВычетаПоПереключателям()
	
	// Анализируем состояние переключателей:
	// Создаем код переключателей формата XYZW, где
	// X - Третий ребенок
	// Y - инвалид I или II группы
	// Z - единственный родитель
	// W - отказ от вычета
	КодПереключателей = 1000* ТретийРебенок+ 100* ИмеетИнвалидность + 10* ЕдинственныйРодитель+ ОтказОтВычетаВторогоРодителя;
	Если КодПереключателей = 0 Тогда
		КодВычета = Справочники.ВычетыНДФЛ.Код108;
	ИначеЕсли КодПереключателей = 1 Тогда
		КодВычета = Справочники.ВычетыНДФЛ.Код111;
	ИначеЕсли КодПереключателей = 10 Тогда
		КодВычета = Справочники.ВычетыНДФЛ.Код119;
	ИначеЕсли КодПереключателей = 100 Тогда
		КодВычета = Справочники.ВычетыНДФЛ.Код109;
	ИначеЕсли КодПереключателей = 101 Тогда
		КодВычета = Справочники.ВычетыНДФЛ.Код113;
	ИначеЕсли КодПереключателей = 110 Тогда
		КодВычета = Справочники.ВычетыНДФЛ.Код112;
	ИначеЕсли КодПереключателей = 1000 Тогда
		КодВычета = Справочники.ВычетыНДФЛ.Код116;
	ИначеЕсли КодПереключателей = 1001 Тогда
		КодВычета = Справочники.ВычетыНДФЛ.Код124;
	ИначеЕсли КодПереключателей = 1010 Тогда
		КодВычета = Справочники.ВычетыНДФЛ.Код120;
	ИначеЕсли КодПереключателей = 1100 Тогда
		КодВычета = Справочники.ВычетыНДФЛ.Код109;
	ИначеЕсли КодПереключателей = 1101 Тогда
		КодВычета = Справочники.ВычетыНДФЛ.Код113;
	ИначеЕсли КодПереключателей = 1110 Тогда
		КодВычета = Справочники.ВычетыНДФЛ.Код112;
	КонецЕсли;
	НаименованиеВычета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КодВычета, "Наименование");
	Если ПустаяСтрока(НаименованиеВычета) Тогда
		НаименованиеВычета = Нстр("ru ='<<Вычет не выбран>>'");
	КонецЕсли;
	
	Возврат Новый Структура("КодВычета, НаименованиеВычета",КодВычета, НаименованиеВычета);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьКодаВычетаВТаблице()
	
	Для Каждого Строка Из ТаблицаВычетовНаДетей Цикл
		Строка.КодВычета = КодВычетаПоНомеруСтроки(Строка.Номер, Строка.КодВычета);
		Строка.НаименованиеВычета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Строка.КодВычета, "Наименование");
		Строка.СуммаВычета = РазмерВычетов.Получить(Строка.КодВычета);
		Строка.Представление = ?(ЗначениеЗаполнено(Строка.КодВычета), Нстр("ru='Код '")+СОКРЛП(Строка.КодВычета), "")
			+?(Строка.СуммаВычета> 0 , ", "+Формат(Строка.СуммаВычета,"ЧЦ=10; ЧДЦ=0; ЧРГ=' '; ЧН=0")+ " руб. ", "");
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция НаименованиеИКодВычетаПоНомеруСтроки(НомерСтроки, ТекущийКод=Неопределено)
	Структура = Новый Структура("Код,Наименование");
	Структура.Код = КодВычетаПоНомеруСтроки(НомерСтроки, ТекущийКод);
	Структура.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Структура.Код, "Наименование");
	
	Возврат Структура;
	
КонецФункции

&НаСервере
Функция КодВычетаПоНомеруСтроки(НомерСтроки, ТекущийКод = Неопределено)
	
	Если ТекущийКод = Неопределено 
		Или Не ЗначениеЗаполнено(ТекущийКод) Тогда
		Если НомерСтроки = 1 Тогда
			Возврат Справочники.ВычетыНДФЛ.Код108;
		ИначеЕсли НомерСтроки = 2 Тогда
			Возврат Справочники.ВычетыНДФЛ.Код115;
		Иначе
			Возврат Справочники.ВычетыНДФЛ.Код116;
		КонецЕсли;
	КонецЕсли;
	
	Код = КодыВычетов.Получить(ТекущийКод);
	
	Если Код = 109 Или Код = 117 Тогда
		// Имеет инвалидность
		Возврат Справочники.ВычетыНДФЛ.Код109;
	ИначеЕсли Код =112 Или Код = 121 Тогда
		// Имеет инвалидность и единственный родитель
		Возврат Справочники.ВычетыНДФЛ.Код112;
	ИначеЕсли Код =113 Или Код = 125 Тогда
		// Имеет инвалидность и отказ от вычета второго родителя
		Возврат Справочники.ВычетыНДФЛ.Код113;
	ИначеЕсли Код =110 Или Код = 118
			ИЛИ Код =119 Или Код = 120 Тогда
		// Единственный родитель
		Если НомерСтроки = 1 Тогда
			Возврат Справочники.ВычетыНДФЛ.Код110;
		ИначеЕсли НомерСтроки = 2 Тогда
			Возврат Справочники.ВычетыНДФЛ.Код119;
		Иначе
			Возврат Справочники.ВычетыНДФЛ.Код120;
		КонецЕсли;
	ИначеЕсли Код =111 Или Код = 122
			ИЛИ Код =123 Или Код = 124 Тогда
		// Отказ от второго родителя
		Если НомерСтроки = 1 Тогда
			Возврат Справочники.ВычетыНДФЛ.Код111;
		ИначеЕсли НомерСтроки = 2 Тогда
			Возврат Справочники.ВычетыНДФЛ.Код123;
		Иначе
			Возврат Справочники.ВычетыНДФЛ.Код124;
		КонецЕсли;
	Иначе
		// Код равен 108, 114, 115, 116 или неопределено
		Если НомерСтроки = 1 Тогда
			Возврат Справочники.ВычетыНДФЛ.Код108;
		ИначеЕсли НомерСтроки = 2 Тогда
			Возврат Справочники.ВычетыНДФЛ.Код115;
		Иначе
			Возврат Справочники.ВычетыНДФЛ.Код116;
		КонецЕсли;
	КонецЕсли;
	
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьНаименованиеКодаВычета(КодВычета) 
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КодВычета, "Наименование");
КонецФункции

Процедура ОпределитьРазмерыВычетовНаДату(АктуальнаяДата)
	
	// Получаем новое соответствие по размерам вычетов
	ЗапросПоРазмерамВычетов = Новый Запрос;
	ЗапросПоРазмерамВычетов.Текст =
	"ВЫБРАТЬ
	|	НДФЛРазмерВычетовСрезПоследних.КодВычета,
	|	НДФЛРазмерВычетовСрезПоследних.Размер
	|ИЗ
	|	РегистрСведений.НДФЛРазмерВычетов.СрезПоследних(&Дата) КАК НДФЛРазмерВычетовСрезПоследних";
	ЗапросПоРазмерамВычетов.УстановитьПараметр("Дата", АктуальнаяДата);
	ВыборкаРазмеровВычетов = ЗапросПоРазмерамВычетов.Выполнить().Выбрать();
	
	СоответствиеВычетов = Новый Соответствие;
	Пока ВыборкаРазмеровВычетов.Следующий() Цикл
		СоответствиеВычетов.Вставить(ВыборкаРазмеровВычетов.КодВычета, ВыборкаРазмеровВычетов.Размер);
	КонецЦикла;
	
	РазмерВычетов = Новый ФиксированноеСоответствие(СоответствиеВычетов);
	
	Для Каждого Строка Из ТаблицаВычетовНаДетей Цикл
		Строка.СуммаВычета = РазмерВычетов.Получить(Строка.КодВычета);
		Строка.Представление = ?(ЗначениеЗаполнено(Строка.КодВычета), Нстр("ru='Код '")+СОКРЛП(Строка.КодВычета), "")
			+?(Строка.СуммаВычета> 0 , ", "+Формат(Строка.СуммаВычета,"ЧЦ=10; ЧДЦ=0; ЧРГ=' '; ЧН=0")+ " руб. ", "");
	КонецЦикла;
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Вычеты по НДФЛ на детей (Итого: %1)'"),
		Формат(ТаблицаВычетовНаДетей.Итог("СуммаВычета"),"ЧЦ=10; ЧДЦ=0; ЧРГ=' '; ЧН=0")+ " руб.");
	
	СписокКодовВычета = Элементы.ТаблицаВычетовНаДетейКодВычета.СписокВыбора;
	СписокКодовВычета.Очистить();
	Для Код = 108 По 125 Цикл
		Попытка
			ЭлементСправочника = ПредопределенноеЗначение("Справочник.ВычетыНДФЛ.Код"+Код);
		Исключение
			Продолжить;
		КонецПопытки;
		КодИНаименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭлементСправочника, "Наименование");
		СписокКодовВычета.Добавить(ЭлементСправочника,
			Нстр("ru='Код '")+Код
			+", "+Формат(РазмерВычетов.Получить(ЭлементСправочника),"ЧЦ=10; ЧДЦ=0; ЧРГ=' '; ЧН=0")+ " руб. ");
	КонецЦикла;
	
КонецПроцедуры
