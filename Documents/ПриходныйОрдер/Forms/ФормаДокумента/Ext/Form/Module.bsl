﻿
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установка реквизитов формы.
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДата();
	КонецЕсли;
	
	Компания = УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(Объект.Организация);
	
	Если НЕ Константы.ФункциональнаяОпцияУчетПоНесколькимСкладам.Получить() Тогда
			
		Элементы.СтруктурнаяЕдиница.РежимВыбораИзСписка = Истина;
			
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.СтруктурнаяЕдиница) Тогда
		
		Если НЕ Объект.СтруктурнаяЕдиница.ОрдерныйСклад Тогда
			
			Объект.СтруктурнаяЕдиница = Неопределено;
			
		ИначеЕсли НЕ Константы.ФункциональнаяОпцияУчетПоНесколькимСкладам.Получить() Тогда
			
			Элементы.СтруктурнаяЕдиница.Видимость = Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
	//Установить текст Основание
	Элементы.ДокументОснованиеНадпись.Заголовок = РаботаСФормойДокументаКлиентСервер.СформироватьНадписьДокументОснование(Объект.ДокументОснование);
	
	ОтчетыУНФ.ПриСозданииНаСервереФормыСвязанногоОбъекта(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	УправлениеНебольшойФирмойСервер.УстановитьОтображаниеПодменюПечати(Элементы.ПодменюПечать);
	
	// ПодключаемоеОборудование
	ИспользоватьПодключаемоеОборудование = УправлениеНебольшойФирмойПовтИсп.ИспользоватьПодключаемоеОборудование();
	СписокЭлектронныхВесов = МенеджерОборудованияВызовСервера.ПолучитьСписокОборудования("ЭлектронныеВесы", , МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента());
	Если СписокЭлектронныхВесов.Количество() = 0 Тогда
		// Нет подключенных весов.
		Элементы.ЗапасыПолучитьВес.Видимость = Ложь;
	КонецЕсли;
	Элементы.ЗапасыЗагрузитьДанныеИзТСД.Видимость = ИспользоватьПодключаемоеОборудование;
	// Конец ПодключаемоеОборудование
	
	// КопированиеСтрокТабличныхЧастей
	КопированиеТабличнойЧастиСервер.ПриСозданииНаСевере(Элементы, "Запасы");
	
	// Серийные номера
	ИспользоватьСерийныеНомераОстатки = РаботаССерийнымиНомерами.ИспользоватьСерийныеНомераОстатки();
	
КонецПроцедуры // ПриСозданииНаСервере()

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры // ПриЧтенииНаСервере()

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода");
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры // ПриОткрытии()

// Процедура - обработчик события ПриЗакрытии.
//
&НаКлиенте
Процедура ПриЗакрытии()
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры // ПриЗакрытии()

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Обсуждения
	ТекущийОбъект.ДополнительныеСвойства.Вставить("Модифицированность",Модифицированность);
	// Конец Обсуждения
	
КонецПроцедуры // ПередЗаписьюНаСервере()

// Процедура - обработчик события ОбработкаОповещения формы.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование"
	   И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" Тогда
			//Преобразуем предварительно к ожидаемому формату
			Данные = Новый Массив();
			Если Параметр[1] = Неопределено Тогда
				Данные.Добавить(Новый Структура("Штрихкод, Количество", Параметр[0], 1)); // Достаем штрихкод из основных данных
			Иначе
				Данные.Добавить(Новый Структура("Штрихкод, Количество", Параметр[1][1], 1)); // Достаем штрихкод из дополнительных данных
			КонецЕсли;
			
			ПолученыШтрихкоды(Данные);
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	Если ИмяСобытия = "ПодборПроизведен" 
		И ЗначениеЗаполнено(Параметр) 
		//Проверка на владельца формы
		И Источник <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000")
		И Источник = УникальныйИдентификатор
		Тогда
		
		АдресЗапасовВХранилище = Параметр;
		
		ПолучитьЗапасыИзХранилища(АдресЗапасовВХранилище, "Запасы", Истина, Истина);
		
	ИначеЕсли ИмяСобытия = "ПодборСерий"
		И ЗначениеЗаполнено(Параметр) 
		//Проверка на владельца формы
		И Источник <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000")
		И Источник = УникальныйИдентификатор
		Тогда
		
		ПолучитьСерийныеНомераИзХранилища(Параметр.АдресВоВременномХранилище, Параметр.КлючСтроки);
		
	КонецЕсли;
	
	// КопированиеСтрокТабличныхЧастей
	Если ИмяСобытия = "БуферОбменаТабличнаяЧастьКопированиеСтрок" Тогда
		КопированиеТабличнойЧастиКлиент.ОбработкаОповещения(Элементы, "Запасы");
	КонецЕсли;
	
	// Обсуждения
	ОбсужденияКлиент.ОбработкаОповещения(ИмяСобытия, Параметр, Источник, ЭтотОбъект, Объект.Ссылка);
	// Конец Обсуждения

КонецПроцедуры // ОбработкаОповещения()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода Дата.
// В процедуре определяется ситуация, когда при изменении своей даты документ 
// оказывается в другом периоде нумерации документов, и в этом случае
// присваивает документу новый уникальный номер.
// Переопределяет соответствующий параметр формы.
//
&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	// Обработка события изменения даты.
	ДатаПередИзменением = ДатаДокумента;
	ДатаДокумента = Объект.Дата;
	Если Объект.Дата <> ДатаПередИзменением Тогда
		СтруктураДанные = ПолучитьДанныеДатаПриИзменении(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
		Если СтруктураДанные.РазностьДат <> 0 Тогда
			Объект.Номер = "";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ДатаПриИзменении()

// Процедура - обработчик события ПриИзменении поля ввода Организация.
// В процедуре осуществляется очистка номера документа,
// а также производится установка параметров функциональных опций формы.
// Переопределяет соответствующий параметр формы.
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	// Обработка события изменения организации.
	Объект.Номер = "";
	СтруктураДанные = ПолучитьДанныеОрганизацияПриИзменении(Объект.Организация);
	Компания = СтруктураДанные.Компания;
	
КонецПроцедуры // ОрганизацияПриИзменении()

// Процедура - обработчик события Открытие поля СтруктурнаяЕдиница.
//
&НаКлиенте
Процедура СтруктурнаяЕдиницаОткрытие(Элемент, СтандартнаяОбработка)
	
	Если Элементы.СтруктурнаяЕдиница.РежимВыбораИзСписка
		И НЕ ЗначениеЗаполнено(Объект.СтруктурнаяЕдиница) Тогда
		
		СтандартнаяОбработка = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры // СтруктурнаяЕдиницаОткрытие()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовПодвалаФормы

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
		
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеНадписьОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если НавигационнаяСсылкаФорматированнойСтроки = "удалить" Тогда
		Объект.ДокументОснование = Неопределено;
		Элементы.ДокументОснованиеНадпись.Заголовок = РаботаСФормойДокументаКлиентСервер.СформироватьНадписьДокументОснование(Неопределено);
		Модифицированность = Истина;
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "заполнить" Тогда
		ЗаполнитьПоОснованиюНачало();
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "выбрать" Тогда
		//Выбрать основание
		СписокОснований = Новый СписокЗначений;
		СписокОснований.Добавить("Документ.ЗаказПоставщику.ФормаВыбора", "Заказ поставщику");
		СписокОснований.Добавить("Документ.ОприходованиеЗапасов.ФормаВыбора", "Оприходование запасов");
		СписокОснований.Добавить("Документ.ПересортицаЗапасов.ФормаВыбора", "Пересортица запасов");
		СписокОснований.Добавить("Документ.ОтчетПереработчика.ФормаВыбора", "Отчет переработчика");
		СписокОснований.Добавить("Документ.ПеремещениеЗапасов.ФормаВыбора", "Перемещение запасов");
		СписокОснований.Добавить("Документ.ПриходнаяНакладная.ФормаВыбора", "Приходная накладная");
		СписокОснований.Добавить("Документ.СборкаЗапасов.ФормаВыбора", "Производство");
		СписокОснований.Добавить("Документ.РасходныйОрдер.ФормаВыбора", "Расходный ордер");
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыборТипаОснованияЗавершение", ЭтотОбъект);
		ПоказатьВыборИзМеню(ОписаниеОповещения, СписокОснований, Элементы.ДокументОснованиеНадпись);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "открыть" Тогда
		
		Если НЕ ЗначениеЗаполнено(Объект.ДокументОснование) тогда
			возврат;
		КонецЕсли;
		
		РаботаСФормойДокументаКлиент.ОткрытьФормуДокументаПоТипу(Объект.ДокументОснование);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборТипаОснованияЗавершение(ВыбИмяФормы, Параметры) Экспорт
	
	Если ВыбИмяФормы<>Неопределено Тогда
		
		СтруктураПараметровОтбора = Новый Структура();
		_ОповещениеОЗакрытии = Новый ОписаниеОповещения("ВыбратьОснованиеЗавершение", ЭтотОбъект);
		ОткрытьФорму(ВыбИмяФормы.Значение, СтруктураПараметровОтбора, ЭтотОбъект, ,,,_ОповещениеОЗакрытии);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьОснованиеЗавершение(ВыбЗначение, Параметры) Экспорт

	Если ВыбЗначение<>Неопределено Тогда
		Объект.ДокументОснование = ВыбЗначение;
		Элементы.ДокументОснованиеНадпись.Заголовок = РаботаСФормойДокументаКлиентСервер.СформироватьНадписьДокументОснование(ВыбЗначение);
		Модифицированность = Истина;
		
		ЗаполнитьПоОснованиюНачало();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОснованиюНачало() Экспорт

	ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьПоОснованиюЗавершение", ЭтотОбъект);
	ПоказатьВопрос(
		ОписаниеОповещения, 
		НСтр("ru = 'Заполнить документ по выбранному основанию?'"), 
		РежимДиалогаВопрос.ДаНет, 0);		

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗапасы

&НаКлиенте
Процедура ЗапасыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И Копирование Тогда
		Элемент.ТекущиеДанные.КлючСвязи = 0;
		Элемент.ТекущиеДанные.СерийныеНомера = "";
	КонецЕсли;	
	
	Если Элемент.ТекущийЭлемент.Имя = "ЗапасыСерийныеНомера" Тогда
		ОткрытьПодборСерийныеНомера();
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Номенклатура.
//
&НаКлиенте
Процедура ЗапасыНоменклатураПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Запасы.ТекущиеДанные;
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("Номенклатура", СтрокаТабличнойЧасти.Номенклатура);
	
	СтруктураДанные = ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные);
	
	СтрокаТабличнойЧасти.ЕдиницаИзмерения = СтруктураДанные.ЕдиницаИзмерения;
	СтрокаТабличнойЧасти.Количество = 1;
	
	//Серийные номера
	Для каждого ВыделеннаяСтрока Из Элементы.Запасы.ВыделенныеСтроки Цикл
		ТекущиеДанныеСтроки = Элементы.Запасы.ДанныеСтроки(ВыделеннаяСтрока);
		РаботаССерийнымиНомерамиКлиентСервер.УдалитьСерийныеНомераПоКлючуСвязи(Объект.СерийныеНомера, ТекущиеДанныеСтроки,,ИспользоватьСерийныеНомераОстатки);
	КонецЦикла;
	
КонецПроцедуры // ЗапасыНоменклатураПриИзменении()

&НаКлиенте
Процедура ЗапасыКоличествоПриИзменении(Элемент)
	
	// Серийные номера
	Если ИспользоватьСерийныеНомераОстатки<>Неопределено Тогда
		РаботаССерийнымиНомерамиКлиентСервер.ОбновитьСерийныеНомераКоличество(Объект, Элементы.Запасы.ТекущиеДанные);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ЗапасыПередУдалением(Элемент, Отказ)
	
	// Серийные номера
	Для каждого ВыделеннаяСтрока Из Элементы.Запасы.ВыделенныеСтроки Цикл
		ТекущиеДанныеСтроки = Элементы.Запасы.ДанныеСтроки(ВыделеннаяСтрока);
		РаботаССерийнымиНомерамиКлиентСервер.УдалитьСерийныеНомераПоКлючуСвязи(Объект.СерийныеНомера, ТекущиеДанныеСтроки,,ИспользоватьСерийныеНомераОстатки);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПоОснованиюЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Ответ = Результат;
    Если Ответ = КодВозвратаДиалога.Да Тогда
        Объект.Запасы.Очистить();
        ЗаполнитьПоДокументу(Объект.ДокументОснование);		
    КонецЕсли;

КонецПроцедуры // ЗаполнитьПоОснованию()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура вызывает обработку заполнения документа по основанию.
//
&НаСервере
Процедура ЗаполнитьПоДокументу(ДокОснование)
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.Заполнить(ДокОснование);
	ЗначениеВРеквизитФормы(Документ, "Объект");
	Модифицированность = Истина;
	
КонецПроцедуры // ЗаполнитьПоДокументу()

// Получает набор данных с сервера для процедуры ДатаПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеДатаПриИзменении(ДокументСсылка, ДатаНовая, ДатаПередИзменением)
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("РазностьДат", УправлениеНебольшойФирмойСервер.ПроверитьНомерДокумента(ДокументСсылка, ДатаНовая, ДатаПередИзменением));
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеДатаПриИзменении()

// Получает набор данных с сервера для процедуры ДоговорПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеОрганизацияПриИзменении(Организация)
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("Компания", УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(Организация));
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеОрганизацияПриИзменении()

// Получает набор данных с сервера для процедуры НоменклатураПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные)
	
	СтруктураДанные.Вставить("ЕдиницаИзмерения", СтруктураДанные.Номенклатура.ЕдиницаИзмерения);
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеНоменклатураПриИзменении()	

// ПодключаемоеОборудование
&НаСервереБезКонтекста
// Процедура получает данные по штрихкодам.
//
Процедура ПолучитьДанныеПоШтрихКодам(СтруктураДанные)
	
	// Преобразование весовых штрихкодов.
	Для каждого ТекШтрихкод Из СтруктураДанные.МассивШтрихкодов Цикл
		
		РегистрыСведений.ШтрихкодыНоменклатуры.ПреобразоватьВесовойШтрихкод(ТекШтрихкод);
		
	КонецЦикла;
	
	ДанныеПоШтрихКодам = РегистрыСведений.ШтрихкодыНоменклатуры.ПолучитьДанныеПоШтрихкодам(СтруктураДанные.МассивШтрихкодов);
	
	Для каждого ТекШтрихкод Из СтруктураДанные.МассивШтрихкодов Цикл
		
		ДанныеШтрихкода = ДанныеПоШтрихкодам[ТекШтрихкод.Штрихкод];
		
		Если ДанныеШтрихкода <> Неопределено
		   И ДанныеШтрихкода.Количество() <> 0 Тогда
			
			СтруктураДанныеНоменклатуры = Новый Структура();
			СтруктураДанныеНоменклатуры.Вставить("Номенклатура", ДанныеШтрихкода.Номенклатура);
			СтруктураДанныеНоменклатуры.Вставить("ТипНоменклатуры", ДанныеШтрихкода.Номенклатура.ТипНоменклатуры);
			ДанныеШтрихкода.Вставить("СтруктураДанныеНоменклатуры", ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанныеНоменклатуры));
			
			Если НЕ ЗначениеЗаполнено(ДанныеШтрихкода.ЕдиницаИзмерения) Тогда
				ДанныеШтрихкода.ЕдиницаИзмерения  = ДанныеШтрихкода.Номенклатура.ЕдиницаИзмерения;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	СтруктураДанные.Вставить("ДанныеПоШтрихКодам", ДанныеПоШтрихКодам);
	
	Для каждого парам Из Метаданные.Документы.ПриходныйОрдер.ТабличныеЧасти.Запасы.Реквизиты.Номенклатура.ПараметрыВыбора Цикл
		Если парам.Имя = "Отбор.ТипНоменклатуры" Тогда
			Если ТипЗнч(парам.Значение)=Тип("ФиксированныйМассив") Тогда
				СтруктураДанные.Вставить("ОтборТипНоменклатуры", парам.Значение);
			Иначе
			    МассивТипов = Новый Массив;
				МассивТипов.Добавить(парам.Значение);
				СтруктураДанные.Вставить("ОтборТипНоменклатуры", МассивТипов);
			КонецЕсли;
			
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // ПолучитьДанныеПоШтрихКодам()

&НаКлиенте
Функция ЗаполнитьПоДаннымШтрихкодов(ДанныеШтрикодов)
	
	НеизвестныеШтрихкоды = Новый Массив;
	ШтрихкодыНекорректногоТипа = Новый Массив;
	
	Если ТипЗнч(ДанныеШтрикодов) = Тип("Массив") Тогда
		МассивШтрихкодов = ДанныеШтрикодов;
	Иначе
		МассивШтрихкодов = Новый Массив;
		МассивШтрихкодов.Добавить(ДанныеШтрикодов);
	КонецЕсли;
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("МассивШтрихкодов", МассивШтрихкодов);
	ПолучитьДанныеПоШтрихКодам(СтруктураДанные);
	
	Для каждого ТекШтрихкод Из СтруктураДанные.МассивШтрихкодов Цикл
		ДанныеШтрихкода = СтруктураДанные.ДанныеПоШтрихкодам[ТекШтрихкод.Штрихкод];
		
		Если ДанныеШтрихкода <> Неопределено
		   И ДанныеШтрихкода.Количество() = 0 Тогда
			НеизвестныеШтрихкоды.Добавить(ТекШтрихкод);
		ИначеЕсли СтруктураДанные.ОтборТипНоменклатуры.Найти(ДанныеШтрихкода.СтруктураДанныеНоменклатуры.ТипНоменклатуры) = Неопределено Тогда
			ШтрихкодыНекорректногоТипа.Добавить(Новый Структура("Штрихкод,Номенклатура,ТипНоменклатуры", ТекШтрихкод.Штрихкод, ДанныеШтрихкода.Номенклатура, ДанныеШтрихкода.СтруктураДанныеНоменклатуры.ТипНоменклатуры));
		Иначе
			МассивСтрокТЧ = Объект.Запасы.НайтиСтроки(Новый Структура("Номенклатура,Характеристика,ЕдиницаИзмерения",ДанныеШтрихкода.Номенклатура,ДанныеШтрихкода.Характеристика,ДанныеШтрихкода.ЕдиницаИзмерения));
			Если МассивСтрокТЧ.Количество() = 0 Тогда
				НоваяСтрока = Объект.Запасы.Добавить();
				НоваяСтрока.Номенклатура = ДанныеШтрихкода.Номенклатура;
				НоваяСтрока.Характеристика = ДанныеШтрихкода.Характеристика;
				НоваяСтрока.Партия = ДанныеШтрихкода.Партия;
				НоваяСтрока.Количество = ТекШтрихкод.Количество;
				НоваяСтрока.ЕдиницаИзмерения = ?(ЗначениеЗаполнено(ДанныеШтрихкода.ЕдиницаИзмерения), ДанныеШтрихкода.ЕдиницаИзмерения, ДанныеШтрихкода.СтруктураДанныеНоменклатуры.ЕдиницаИзмерения);
				Элементы.Запасы.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
			Иначе
				НоваяСтрока = МассивСтрокТЧ[0];
				НоваяСтрока.Количество = НоваяСтрока.Количество + ТекШтрихкод.Количество;
				Элементы.Запасы.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
			КонецЕсли;
			
			Если ДанныеШтрихкода.Свойство("СерийныйНомер") И ЗначениеЗаполнено(ДанныеШтрихкода.СерийныйНомер) Тогда
				РаботаССерийнымиНомерамиКлиентСервер.ДобавитьСерийныйНомерВСтроку(НоваяСтрока, ДанныеШтрихкода.СерийныйНомер, Объект);
			КонецЕсли;

		КонецЕсли;
	КонецЦикла;
	
	Возврат Новый Структура("НеизвестныеШтрихкоды, ШтрихкодыНекорректногоТипа",НеизвестныеШтрихкоды, ШтрихкодыНекорректногоТипа);КонецФункции // ЗаполнитьПоДаннымШтрихкодов()

// Процедура обрабатывает полученные штрихкоды.
//
&НаКлиенте
Процедура ПолученыШтрихкоды(ДанныеШтрикодов) Экспорт
	
	Модифицированность = Истина;
	
	НедобавленныеШтрихкоды		= ЗаполнитьПоДаннымШтрихкодов(ДанныеШтрикодов);
	НеизвестныеШтрихкоды		= НедобавленныеШтрихкоды.НеизвестныеШтрихкоды;
	ШтрихкодыНекорректногоТипа	= НедобавленныеШтрихкоды.ШтрихкодыНекорректногоТипа;
	
	ПолученыШтрихкодыНекорректногоТипа(ШтрихкодыНекорректногоТипа);
	
	Если НеизвестныеШтрихкоды.Количество() > 0 Тогда
		
		Оповещение = Новый ОписаниеОповещения("ПолученыШтрихкодыЗавершение", ЭтотОбъект, НеизвестныеШтрихкоды);
		
		ОткрытьФорму(
			"РегистрСведений.ШтрихкодыНоменклатуры.Форма.РегистрацияШтрихкодовНоменклатуры",
			Новый Структура("НеизвестныеШтрихкоды", НеизвестныеШтрихкоды), ЭтотОбъект,,,,Оповещение
		);
		
		Возврат;
		
	КонецЕсли;
	
	ПолученыШтрихкодыФрагмент(НеизвестныеШтрихкоды);
	
КонецПроцедуры // ПолученыШтрихкоды()

&НаКлиенте
Процедура ПолученыШтрихкодыЗавершение(ВозвращаемыеПараметры, Параметры) Экспорт
	
	НеизвестныеШтрихкоды = Параметры;
	
	Если ВозвращаемыеПараметры <> Неопределено Тогда
		
		МассивШтрихкодов = Новый Массив;
		
		Для каждого ЭлементМассива Из ВозвращаемыеПараметры.ЗарегистрированныеШтрихкоды Цикл
			МассивШтрихкодов.Добавить(ЭлементМассива);
		КонецЦикла;
		
		Для каждого ЭлементМассива Из ВозвращаемыеПараметры.ПолученыНовыеШтрихкоды Цикл
			МассивШтрихкодов.Добавить(ЭлементМассива);
		КонецЦикла;
		
		НедобавленныеШтрихкоды		= ЗаполнитьПоДаннымШтрихкодов(МассивШтрихкодов);
		НеизвестныеШтрихкоды		= НедобавленныеШтрихкоды.НеизвестныеШтрихкоды;
		ШтрихкодыНекорректногоТипа	= НедобавленныеШтрихкоды.ШтрихкодыНекорректногоТипа;
		ПолученыШтрихкодыНекорректногоТипа(ШтрихкодыНекорректногоТипа);
	КонецЕсли;
	
	ПолученыШтрихкодыФрагмент(НеизвестныеШтрихкоды);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолученыШтрихкодыФрагмент(НеизвестныеШтрихкоды) Экспорт
	
	Для каждого ТекНеизвестныйШтрихкод Из НеизвестныеШтрихкоды Цикл
		
		СтрокаСообщения = НСтр("ru = 'Данные по штрихкоду не найдены: %1%; количество: %2%'");
		СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%1%", ТекНеизвестныйШтрихкод.Штрихкод);
		СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%2%", ТекНеизвестныйШтрихкод.Количество);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолученыШтрихкодыНекорректногоТипа(ШтрихкодыНекорректногоТипа) Экспорт
	
	Для каждого ТекНекорректныйШтрихкод Из ШтрихкодыНекорректногоТипа Цикл
		
		СтрокаСообщения = НСтр("ru = 'Найденная по штрихкоду %1% номенклатура -%2%- имеет тип %3%, который не подходит для этой табличной части'");
		СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%1%", ТекНекорректныйШтрихкод.Штрихкод);
		СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%2%", ТекНекорректныйШтрихкод.Номенклатура);
		СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%3%", ТекНекорректныйШтрихкод.ТипНоменклатуры);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения);
		
	КонецЦикла;
	
КонецПроцедуры

// Конец ПодключаемоеОборудование

#КонецОбласти

#Область ЗаполнениеОбъектов

&НаКлиенте
Процедура СохранитьДокументКакШаблон(Параметр) Экспорт
	
	ЗаполнениеОбъектовУНФКлиент.СохранитьДокументКакШаблон(Объект, ОтображаемыеРеквизиты(), Параметр);
	
КонецПроцедуры

&НаСервере
Функция ОтображаемыеРеквизиты()
	
	Возврат ЗаполнениеОбъектовУНФ.ОтображаемыеРеквизиты(ЭтотОбъект);
	
КонецФункции

#КонецОбласти

#Область КопированиеСтрокТабличныхЧастей

// Процедура - обработчик нажатия кнопки Копировать строки в ТЧ Запасы.
//
&НаКлиенте
Процедура ЗапасыКопироватьСтроки(Команда)
	
	КопироватьСтроки("Запасы");
	
КонецПроцедуры

// Процедура - обработчик нажатия кнопки Вставить строки в ТЧ Запасы.
//
&НаКлиенте
Процедура ЗапасыВставитьСтроки(Команда)
	
	ВставитьСтроки("Запасы");
	
КонецПроцедуры

// Вызывает процедуру копирования строк и оповещает пользователя о количестве скопированных.
//
&НаКлиенте
Процедура КопироватьСтроки(ИмяТЧ)
	
	Если КопированиеТабличнойЧастиКлиент.МожноКопироватьСтроки(Объект[ИмяТЧ], Элементы[ИмяТЧ].ТекущиеДанные) Тогда
		КоличествоСкопированных = 0;
		КопироватьСтрокиНаСервере(ИмяТЧ, КоличествоСкопированных);
		КопированиеТабличнойЧастиКлиент.ОповеститьПользователяОКопированииСтрок(КоличествоСкопированных);
	КонецЕсли;
	
КонецПроцедуры

// Вызывает процедуру вставки строк и оповещает пользователя о количетсве вставленных.
//
&НаКлиенте
Процедура ВставитьСтроки(ИмяТЧ)
	
	КоличествоСкопированных = 0;
	КоличествоВставленных = 0;
	ВставитьСтрокиНаСервере(ИмяТЧ, КоличествоСкопированных, КоличествоВставленных);
	КопированиеТабличнойЧастиКлиент.ОповеститьПользователяОВставкеСтрок(КоличествоСкопированных, КоличествоВставленных);
	
КонецПроцедуры

// Выполняет копирование выделенных строк в буфер обмена.
//
&НаСервере
Процедура КопироватьСтрокиНаСервере(ИмяТЧ, КоличествоСкопированных)
	
	КопированиеТабличнойЧастиСервер.Копировать(Объект[ИмяТЧ], Элементы[ИмяТЧ].ВыделенныеСтроки, КоличествоСкопированных);
	
КонецПроцедуры

// Вставляет скопированные строки из буфера обмена в выбранную табличную часть.
//
&НаСервере
Процедура ВставитьСтрокиНаСервере(ИмяТЧ, КоличествоСкопированных, КоличествоВставленных)
	
	КопированиеТабличнойЧастиСервер.Вставить(Объект, ИмяТЧ, Элементы, КоличествоСкопированных, КоличествоВставленных);
	ОбработатьВставленныеСтрокиНаСервере(ИмяТЧ, КоличествоВставленных);
	
КонецПроцедуры

// Обрабатывает вставленные строки.
//
&НаСервере
Процедура ОбработатьВставленныеСтрокиНаСервере(ИмяТЧ, КоличествоВставленных)
	
	Количество = Объект[ИмяТЧ].Количество();
	
	Для Итератор = 1 По КоличествоВставленных Цикл
		
		Строка = Объект[ИмяТЧ][Количество - Итератор];
		
		СтруктураДанные = Новый Структура;
		СтруктураДанные.Вставить("Номенклатура", Строка.Номенклатура);
		
		СтруктураДанные = ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные);
		Если НЕ ЗначениеЗаполнено(Строка.ЕдиницаИзмерения) Тогда
			Строка.ЕдиницаИзмерения = СтруктураДанные.ЕдиницаИзмерения;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСПодбором

// Процедура - обработчик события Действие команды Подбор
//
&НаКлиенте
Процедура Подбор(Команда)
	
	ИмяТабличнойЧасти 	= "Запасы";
	
	ПараметрыПодбора = Новый Структура;
	
	ПараметрыПодбора.Вставить("Период", 				Объект.Дата);
	ПараметрыПодбора.Вставить("Организация", 			Компания);
	ПараметрыПодбора.Вставить("СтруктурнаяЕдиница", 	Объект.СтруктурнаяЕдиница);
	
	ПараметрыПодбора.Вставить("ЭтоПриходныйДокумент",	Истина);
	
	ТипНоменклатуры = Новый СписокЗначений;
	Для каждого ЭлементМассива Из Элементы[ИмяТабличнойЧасти + "Номенклатура"].ПараметрыВыбора Цикл
		Если ЭлементМассива.Имя = "Отбор.ТипНоменклатуры" Тогда
			Если ТипЗнч(ЭлементМассива.Значение) = Тип("ФиксированныйМассив") Тогда
				Для каждого ЭлементФиксМассива Из ЭлементМассива.Значение Цикл
					ТипНоменклатуры.Добавить(ЭлементФиксМассива);
				КонецЦикла; 
			Иначе
				ТипНоменклатуры.Добавить(ЭлементМассива.Значение);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	ПараметрыПодбора.Вставить("ТипНоменклатуры", ТипНоменклатуры);
	
	ПараметрыПодбора.Вставить("УникальныйИдентификаторФормыВладельца", УникальныйИдентификатор);
	
	ОткрытьФорму("ОбщаяФорма.ФормаПодбора", ПараметрыПодбора, ЭтотОбъект);
	
КонецПроцедуры // ПодборВыполнить()

// Функция получает список товаров из временного хранилища
//
&НаСервере
Процедура ПолучитьЗапасыИзХранилища(АдресЗапасовВХранилище, ИмяТабличнойЧасти, ЕстьХарактеристики, ЕстьПартии)
	
	ТаблицаДляЗагрузки = ПолучитьИзВременногоХранилища(АдресЗапасовВХранилище);
	
	Для каждого СтрокаЗагрузки Из ТаблицаДляЗагрузки Цикл
		
		НоваяСтрока = Объект[ИмяТабличнойЧасти].Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗагрузки);
		
	КонецЦикла;
	
КонецПроцедуры // ПолучитьЗапасыИзХранилища()

// ПодключаемоеОборудование
// Процедура - обработчик команды командной панели табличной части.
//
&НаКлиенте
Процедура ПоискПоШтрихкоду(Команда)
	
	ТекШтрихкод = "";
	ПоказатьВводЗначения(Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект, Новый Структура("ТекШтрихкод", ТекШтрихкод)), ТекШтрихкод, НСтр("ru = 'Введите штрихкод'"));

КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ТекШтрихкод = ?(Результат = Неопределено, ДополнительныеПараметры.ТекШтрихкод, Результат);
    
    
    Если НЕ ПустаяСтрока(ТекШтрихкод) Тогда
        ПолученыШтрихкоды(Новый Структура("Штрихкод, Количество", ТекШтрихкод, 1));
    КонецЕсли;

КонецПроцедуры // ПоискПоШтрихкоду()

// Процедура - обработчик события Действие команды ПолучитьВес
//
&НаКлиенте
Процедура ПолучитьВес(Команда)
	
	ПодключаемоеОборудованиеУНФКлиент.ПолучениеВесаСЭлектронныхВесовДляТабличнойЧасти(ЭтотОбъект, "Запасы", Ложь);
	
КонецПроцедуры // ПолучитьВес()

// Процедура - обработчик команды ЗагрузитьДанныеИзТСД.
//
&НаКлиенте
Процедура ЗагрузитьДанныеИзТСД(Команда)
	
	ПодключаемоеОборудованиеУНФКлиент.ПолучитьДанныеИзТСД(ЭтотОбъект);
	
КонецПроцедуры // ЗагрузитьДанныеИзТСД()

// Конец ПодключаемоеОборудование

#КонецОбласти

#Область РаботаССерийнымиНомерами

&НаКлиенте
Процедура ЗапасыСерийныеНомераНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
		
	СтандартнаяОбработка = Ложь;
	ОткрытьПодборСерийныеНомера();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборСерийныеНомера()
		
	ТекущиеДанныеИдентификатор = Элементы.Запасы.ТекущиеДанные.ПолучитьИдентификатор();
	ПараметрыСерийныхНомеров = ПараметрыПодбораСерийныхНомеров(ТекущиеДанныеИдентификатор);
	
	ОткрытьФорму("Обработка.ПодборСерийныхНомеров.Форма", ПараметрыСерийныхНомеров, ЭтотОбъект);

КонецПроцедуры

Функция ПолучитьСерийныеНомераИзХранилища(АдресВоВременномХранилище, КлючСтроки)
	
	Модифицированность = Истина;
	Возврат РаботаСФормойДокумента.ПолучитьСерийныеНомераИзХранилища(Объект, АдресВоВременномХранилище, КлючСтроки);
	
КонецФункции

Функция ПараметрыПодбораСерийныхНомеров(ТекущиеДанныеИдентификатор)
	
	Возврат РаботаСФормойДокумента.ПараметрыПодбораСерийныхНомеров(Объект, ЭтотОбъект.УникальныйИдентификатор, ТекущиеДанныеИдентификатор, Ложь);
	
КонецФункции

// Конец ПодключаемоеОборудование

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтотОбъект, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтотОбъект, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Объект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

#КонецОбласти
