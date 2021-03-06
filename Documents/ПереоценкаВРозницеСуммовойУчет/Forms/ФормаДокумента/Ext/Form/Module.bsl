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
	
	Если Объект.Запасы.Количество() = 0 Тогда
		НоваяСтрока = Объект.Запасы.Добавить();
	КонецЕсли;
	
	// Установка доступности цен для редактирования.
	РазрешеноРедактированиеЦенДокументов = УправлениеНебольшойФирмойУправлениеДоступомПовтИсп.РазрешеноРедактированиеЦенДокументов();
	
	Элементы.ЗапасыЦена.ТолькоПросмотр  	= НЕ РазрешеноРедактированиеЦенДокументов;
	Элементы.ЗапасыНоваяЦена.ТолькоПросмотр = НЕ РазрешеноРедактированиеЦенДокументов;
	Элементы.ЗапасыСумма.ТолькоПросмотр 	= НЕ РазрешеноРедактированиеЦенДокументов;
	
	ОтчетыУНФ.ПриСозданииНаСервереФормыСвязанногоОбъекта(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаВажныеКоманды);
	// Конец СтандартныеПодсистемы.Печать
	
	// ПодключаемоеОборудование
	ИспользоватьПодключаемоеОборудование = УправлениеНебольшойФирмойПовтИсп.ИспользоватьПодключаемоеОборудование();
	СписокЭлектронныхВесов = МенеджерОборудованияВызовСервера.ПолучитьСписокОборудования("ЭлектронныеВесы", , МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента());
	Если СписокЭлектронныхВесов.Количество() = 0 Тогда
		// Нет подключенных весов.
		Элементы.ЗапасыПолучитьВес.Видимость = Ложь;
	КонецЕсли;
	Элементы.ЗапасыЗагрузитьДанныеИзТСД.Видимость = ИспользоватьПодключаемоеОборудование;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры // ПриСозданииНаСервере()

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры // ПриЧтенииНаСервере()

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	КоличествоСтрок = Объект.Запасы.Количество();
	
	ЗаполненаХотьОднаКолонка = Ложь;
	Если КоличествоСтрок = 1 Тогда
		ЗаполненаХотьОднаКолонка = ЗначениеЗаполнено(Объект.Запасы[0].Номенклатура)
			ИЛИ ЗначениеЗаполнено(Объект.Запасы[0].Характеристика)
			ИЛИ ЗначениеЗаполнено(Объект.Запасы[0].Партия)
			ИЛИ ЗначениеЗаполнено(Объект.Запасы[0].Количество)
			ИЛИ ЗначениеЗаполнено(Объект.Запасы[0].ЕдиницаИзмерения)
			ИЛИ ЗначениеЗаполнено(Объект.Запасы[0].Цена)
			ИЛИ ЗначениеЗаполнено(Объект.Запасы[0].НоваяЦена);
	КонецЕсли;
	
	Элементы.РедактироватьСписком.Пометка = КоличествоСтрок > 1 ИЛИ ЗаполненаХотьОднаКолонка;
	
	Если КоличествоСтрок > 0 Тогда
		Элементы.Запасы.ТекущаяСтрока = Объект.Запасы[0].ПолучитьИдентификатор();
	КонецЕсли;
	
	УстановитьВозможностьРедактированияСпискомФрагмент();
	
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
	
	Если ИмяСобытия = "ОбновлениеТекстаПроСчетФактуру" Тогда
		Если ТипЗнч(Параметр) = Тип("Структура") Тогда
			Если Параметр.ДокументОснование = Объект.Ссылка Тогда
				СчетФактураТекст = Параметр.Представление;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ОбработкаОповещения()

// Процедура - обработчик команды РедактироватьСписком.
//
&НаКлиенте
Процедура РедактироватьСписком(Команда)
	
	УстановитьВозможностьРедактированияСписком();

КонецПроцедуры // РедактироватьСписком()

// Процедура - устанавливает возможность редактирования списком.
//
&НаКлиенте
Процедура УстановитьВозможностьРедактированияСписком()
	
	Элементы.РедактироватьСписком.Пометка = НЕ Элементы.РедактироватьСписком.Пометка;
	
	КоличествоСтрок = Объект.Запасы.Количество();
	
	ЗаполненаХотьОднаКолонка = Ложь;
	Если КоличествоСтрок = 1 Тогда
		ЗаполненаХотьОднаКолонка = ЗначениеЗаполнено(Объект.Запасы[0].Номенклатура)
			ИЛИ ЗначениеЗаполнено(Объект.Запасы[0].Характеристика)
			ИЛИ ЗначениеЗаполнено(Объект.Запасы[0].Партия)
			ИЛИ ЗначениеЗаполнено(Объект.Запасы[0].Количество)
			ИЛИ ЗначениеЗаполнено(Объект.Запасы[0].ЕдиницаИзмерения)
			ИЛИ ЗначениеЗаполнено(Объект.Запасы[0].Цена)
			ИЛИ ЗначениеЗаполнено(Объект.Запасы[0].НоваяЦена);
	КонецЕсли;
	
	Если НЕ Элементы.РедактироватьСписком.Пометка
		  И (КоличествоСтрок > 1
		 ИЛИ ЗаполненаХотьОднаКолонка) Тогда
		
		Ответ = Неопределено;

		
		ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьВозможностьРедактированияСпискомЗавершение", ЭтотОбъект), 
			НСтр("ru='Все строки будут свернуты. Продолжить?'"),
			РежимДиалогаВопрос.ДаНет
		);
        Возврат;
	КонецЕсли;
	
	УстановитьВозможностьРедактированияСпискомФрагмент();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВозможностьРедактированияСпискомЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Ответ = Результат;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Элементы.РедактироватьСписком.Пометка = Истина;
        Возврат;
    КонецЕсли;
    
    СуммаПереоценки = Объект.Запасы.Итог("Сумма");
    
    Объект.Запасы.Очистить();
    НовСтрока = Объект.Запасы.Добавить();
    НовСтрока.Сумма = СуммаПереоценки;
    
    Элементы.Запасы.ТекущаяСтрока = НовСтрока.ПолучитьИдентификатор();
    
    УстановитьВозможностьРедактированияСпискомФрагмент();

КонецПроцедуры

&НаСервере
Процедура УстановитьВозможностьРедактированияСпискомФрагмент()
	
	Если Элементы.РедактироватьСписком.Пометка Тогда
		Элементы.Запасы.Видимость = Истина;
		Элементы.ЗапасыИтогСумма.Видимость = Истина;
		Элементы.Сумма.Видимость = Ложь; 
		Элементы.ДекорацияРазделитель.Видимость = Ложь;
	Иначе
		Элементы.Запасы.Видимость = Ложь;
		Элементы.ЗапасыИтогСумма.Видимость = Ложь;
		Элементы.Сумма.Видимость = Истина;
		Элементы.ДекорацияРазделитель.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры // УстановитьВозможностьРедактированияСписком()

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
	
	ПодключаемоеОборудованиеУНФКлиент.ПолучениеВесаСЭлектронныхВесовДляТабличнойЧасти(ЭтаФорма, "Запасы");
	
КонецПроцедуры // ПолучитьВес()

&НаКлиенте
Процедура ПолучитьВесЗавершение(Параметры) Экспорт
	
	СтрокаТабличнойЧасти = Параметры;
	РассчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТабличнойЧасти);
	
КонецПроцедуры

// Процедура - обработчик команды ЗагрузитьДанныеИзТСД.
//
&НаКлиенте
Процедура ЗагрузитьДанныеИзТСД(Команда)
	
	ПодключаемоеОборудованиеУНФКлиент.ПолучитьДанныеИзТСД(ЭтаФорма);
	
КонецПроцедуры // ЗагрузитьДанныеИзТСД()

// Конец ПодключаемоеОборудование

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

// Процедура - обработчик события ПриИзменении поля ввода СтруктурнаяЕдиница.
//
&НаКлиенте
Процедура СтруктурнаяЕдиницаПриИзменении(Элемент)
	
	СтруктураДанные = ПолучитьДанныеСтруктурнаяЕдиницаПриИзменении(Объект.СтруктурнаяЕдиница);
	Объект.ВидЦен = СтруктураДанные.РозничныйВидЦен;
	Объект.ВалютаДокумента = СтруктураДанные.ВалютаЦены;
	Объект.Корреспонденция = СтруктураДанные.СчетУчетаНаценки;
	
	КоличествоСтрок = Объект.Запасы.Количество();
	
	ЗаполненаХотьОднаКолонка = Ложь;
	Если КоличествоСтрок = 1 Тогда
		ЗаполненаХотьОднаКолонка = ЗначениеЗаполнено(Объект.Запасы[0].Номенклатура)
			ИЛИ ЗначениеЗаполнено(Объект.Запасы[0].Характеристика)
			ИЛИ ЗначениеЗаполнено(Объект.Запасы[0].Партия)
			ИЛИ ЗначениеЗаполнено(Объект.Запасы[0].Количество)
			ИЛИ ЗначениеЗаполнено(Объект.Запасы[0].ЕдиницаИзмерения)
			ИЛИ ЗначениеЗаполнено(Объект.Запасы[0].Цена)
			ИЛИ ЗначениеЗаполнено(Объект.Запасы[0].НоваяЦена);
	КонецЕсли;
	
	Если КоличествоСтрок > 1 ИЛИ ЗаполненаХотьОднаКолонка Тогда 
		ПерезаполнитьЦеныТабличнойЧастиПоВидуЦен();
	КонецЕсли;
	
КонецПроцедуры // СтруктурнаяЕдиницаПриИзменении()

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗапасы

// Процедура - обработчик события ПриИзменении поля ввода Номенклатура.
//
&НаКлиенте
Процедура ЗапасыНоменклатураПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Запасы.ТекущиеДанные;
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("Организация", Компания);
	СтруктураДанные.Вставить("Номенклатура", СтрокаТабличнойЧасти.Номенклатура);
	СтруктураДанные.Вставить("Характеристика",	 СтрокаТабличнойЧасти.Характеристика);
		
	Если ЗначениеЗаполнено(Объект.ВидЦен) Тогда
		
		СтруктураДанные.Вставить("ДатаОбработки",	 Объект.Дата);
		СтруктураДанные.Вставить("ВалютаДокумента",  Объект.ВалютаДокумента);
		СтруктураДанные.Вставить("СуммаВключаетНДС", Истина);
		СтруктураДанные.Вставить("ВидЦен", Объект.ВидЦен);
		СтруктураДанные.Вставить("Коэффициент", 1);
					
	КонецЕсли;
	
	СтруктураДанные = ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные);
	
	СтрокаТабличнойЧасти.ЕдиницаИзмерения = СтруктураДанные.ЕдиницаИзмерения;
	СтрокаТабличнойЧасти.Количество = 1;
	СтрокаТабличнойЧасти.Цена = СтруктураДанные.Цена;
	
	РассчитатьСуммуВСтрокеТабличнойЧасти();
	
КонецПроцедуры // ЗапасыНоменклатураПриИзменении()

// Процедура - обработчик события ПриИзменении поля ввода Характеристика.
//
&НаКлиенте
Процедура ЗапасыХарактеристикаПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Запасы.ТекущиеДанные;
		
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("Номенклатура",   СтрокаТабличнойЧасти.Номенклатура);
	СтруктураДанные.Вставить("Характеристика", СтрокаТабличнойЧасти.Характеристика);
		
	Если ЗначениеЗаполнено(Объект.ВидЦен) Тогда
		
		СтруктураДанные.Вставить("ДатаОбработки",	 Объект.Дата);
		СтруктураДанные.Вставить("ВалютаДокумента",	 Объект.ВалютаДокумента);
		СтруктураДанные.Вставить("Цена",			 СтрокаТабличнойЧасти.Цена);
		СтруктураДанные.Вставить("ВидЦен",			 Объект.ВидЦен);
		СтруктураДанные.Вставить("ЕдиницаИзмерения", СтрокаТабличнойЧасти.ЕдиницаИзмерения);
		
	КонецЕсли;
				
	СтруктураДанные = ПолучитьДанныеХарактеристикаПриИзменении(СтруктураДанные);
	
	СтрокаТабличнойЧасти.Цена = СтруктураДанные.Цена;
				
	РассчитатьСуммуВСтрокеТабличнойЧасти();
	
КонецПроцедуры // ЗапасыХарактеристикаПриИзменении()

// Процедура - обработчик события ОбработкаВыбора поля ввода ЕдиницаИзмерения.
//
&НаКлиенте
Процедура ЗапасыЕдиницаИзмеренияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтрокаТабличнойЧасти = Элементы.Запасы.ТекущиеДанные;
	
	Если СтрокаТабличнойЧасти.ЕдиницаИзмерения = ВыбранноеЗначение 
		ИЛИ СтрокаТабличнойЧасти.Цена = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийКоэффициент = 0;
	Если ТипЗнч(СтрокаТабличнойЧасти.ЕдиницаИзмерения) = Тип("СправочникСсылка.КлассификаторЕдиницИзмерения") Тогда
		ТекущийКоэффициент = 1;
	КонецЕсли;
	
	Коэффициент = 0;
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.КлассификаторЕдиницИзмерения") Тогда
		Коэффициент = 1;
	КонецЕсли;
	
	Если ТекущийКоэффициент = 0 И Коэффициент = 0 Тогда
		СтруктураДанные = ПолучитьДанныеЕдиницаИзмеренияПриИзменении(СтрокаТабличнойЧасти.ЕдиницаИзмерения, ВыбранноеЗначение);
	ИначеЕсли ТекущийКоэффициент = 0 Тогда
		СтруктураДанные = ПолучитьДанныеЕдиницаИзмеренияПриИзменении(СтрокаТабличнойЧасти.ЕдиницаИзмерения);
	ИначеЕсли Коэффициент = 0 Тогда
		СтруктураДанные = ПолучитьДанныеЕдиницаИзмеренияПриИзменении(,ВыбранноеЗначение);
	ИначеЕсли ТекущийКоэффициент = 1 И Коэффициент = 1 Тогда
		СтруктураДанные = Новый Структура("ТекущийКоэффициент, Коэффициент", 1, 1);
	КонецЕсли;
	
	// Цена.
	Если СтруктураДанные.ТекущийКоэффициент <> 0 Тогда
		СтрокаТабличнойЧасти.Цена = СтрокаТабличнойЧасти.Цена * СтруктураДанные.Коэффициент / СтруктураДанные.ТекущийКоэффициент;
	КонецЕсли;
	
	РассчитатьСуммуВСтрокеТабличнойЧасти();
	
КонецПроцедуры // ЗапасыЕдиницаИзмеренияОбработкаВыбора()

// Процедура - обработчик события ПриИзменении поля ввода Количество.
//
&НаКлиенте
Процедура ЗапасыКоличествоПриИзменении(Элемент)
	
	РассчитатьСуммуВСтрокеТабличнойЧасти();
	
КонецПроцедуры // ЗапасыКоличествоПриИзменении()

// Процедура - обработчик события ПриИзменении поля ввода Цена.
//
&НаКлиенте
Процедура ЗапасыЦенаПриИзменении(Элемент)
	
	РассчитатьСуммуВСтрокеТабличнойЧасти();
	
КонецПроцедуры // ЗапасыЦенаПриИзменении()

// Процедура - обработчик события ПриИзменении поля ввода Сумма.
//
&НаКлиенте
Процедура ЗапасыСуммаПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Запасы.ТекущиеДанные;
	
	// Цена.
	Если СтрокаТабличнойЧасти.Количество <> 0 Тогда
		СтрокаТабличнойЧасти.НоваяЦена = СтрокаТабличнойЧасти.Сумма / СтрокаТабличнойЧасти.Количество + СтрокаТабличнойЧасти.Цена;
	КонецЕсли;
	
КонецПроцедуры // ЗапасыСуммаПриИзменении()

// Процедура - обработчик события ПриИзменении поля ввода НоваяЦена.
//
&НаКлиенте
Процедура ЗапасыНоваяЦенаПриИзменении(Элемент)
	
	РассчитатьСуммуВСтрокеТабличнойЧасти();

КонецПроцедуры // ЗапасыНоваяЦенаПриИзменении()

// Процедура - обработчик события ПередУдалением табличной части Запасы.
//
&НаКлиенте
Процедура ЗапасыПередУдалением(Элемент, Отказ)
	
	Если Объект.Запасы.Количество() = 1 Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняем пересчет цены табличной части документа.
//
&НаКлиенте
Процедура ПерезаполнитьЦеныТабличнойЧастиПоВидуЦен()
	
	СтруктураДанных = Новый Структура;
	ТабличнаяЧастьДокумента = Новый Массив;

	СтруктураДанных.Вставить("Дата",				Объект.Дата);
	СтруктураДанных.Вставить("Организация",			Компания);
	СтруктураДанных.Вставить("ВидЦен",				Объект.ВидЦен);
	СтруктураДанных.Вставить("ВалютаДокумента",		Объект.ВалютаДокумента);
		
	Для каждого СтрокаТЧ Из Объект.Запасы Цикл
		СтрокаТЧ.Цена = 0;
		СтрокаТабличнойЧасти = Новый Структура();
		СтрокаТабличнойЧасти.Вставить("Номенклатура",		СтрокаТЧ.Номенклатура);
		СтрокаТабличнойЧасти.Вставить("Характеристика",		СтрокаТЧ.Характеристика);
		СтрокаТабличнойЧасти.Вставить("ЕдиницаИзмерения",	СтрокаТЧ.ЕдиницаИзмерения);
		СтрокаТабличнойЧасти.Вставить("Цена",				0);
		ТабличнаяЧастьДокумента.Добавить(СтрокаТабличнойЧасти);
	КонецЦикла;
		
	УправлениеНебольшойФирмойСервер.ПолучитьЦеныТабличнойЧастиПоВидуЦен(СтруктураДанных, ТабличнаяЧастьДокумента);
		
	Для каждого СтрокаТЧ Из ТабличнаяЧастьДокумента Цикл
  		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Номенклатура",		СтрокаТЧ.Номенклатура);
		СтруктураПоиска.Вставить("Характеристика",		СтрокаТЧ.Характеристика);
		СтруктураПоиска.Вставить("ЕдиницаИзмерения",	СтрокаТЧ.ЕдиницаИзмерения);
		РезультатПоиска = Объект.Запасы.НайтиСтроки(СтруктураПоиска);
		
		Для каждого СтрокаРезультат Из РезультатПоиска Цикл
			СтрокаРезультат.Цена = СтрокаТЧ.Цена;
			СтрокаРезультат.Сумма = СтрокаРезультат.Количество * СтрокаРезультат.НоваяЦена - СтрокаРезультат.Количество * СтрокаРезультат.Цена;
		КонецЦикла;		
	КонецЦикла;
	
КонецПроцедуры // ПерезаполнитьЦеныТабличнойЧастиПоВидуЦен()

// Получает набор данных с сервера для процедуры ДатаПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеДатаПриИзменении(ДокументСсылка, ДатаНовая, ДатаПередИзменением)
	
	СтруктураДанные = Новый Структура;
	
	СтруктураДанные.Вставить("РазностьДат", УправлениеНебольшойФирмойСервер.ПроверитьНомерДокумента(ДокументСсылка, ДатаНовая, ДатаПередИзменением));
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеДатаПриИзменении()

// Получает набор данных с сервера для процедуры НоменклатураПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные)
	
	СтруктураДанные.Вставить("ЕдиницаИзмерения", СтруктураДанные.Номенклатура.ЕдиницаИзмерения);
	
	Если СтруктураДанные.Свойство("ВидЦен") Тогда
		Цена = УправлениеНебольшойФирмойСервер.ПолучитьЦенуНоменклатурыПоВидуЦен(СтруктураДанные);
		СтруктураДанные.Вставить("Цена", Цена);
	Иначе
		СтруктураДанные.Вставить("Цена", 0);
	КонецЕсли;
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеНоменклатураПриИзменении()

// Процедура рассчитывает сумму в строке табличной части.
//
&НаКлиенте
Процедура РассчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТабличнойЧасти = Неопределено)
	
	Если СтрокаТабличнойЧасти = Неопределено Тогда
		СтрокаТабличнойЧасти = Элементы.Запасы.ТекущиеДанные;
	КонецЕсли;
	
	СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Количество * СтрокаТабличнойЧасти.НоваяЦена - СтрокаТабличнойЧасти.Количество * СтрокаТабличнойЧасти.Цена;
	
КонецПроцедуры // РассчитатьСуммуВСтрокеТабличнойЧасти()

// Получает набор данных с сервера для процедуры ХарактеристикаПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеХарактеристикаПриИзменении(СтруктураДанные)
	
	Если СтруктураДанные.Свойство("ВидЦен") Тогда
		Если ТипЗнч(СтруктураДанные.ЕдиницаИзмерения) = Тип("СправочникСсылка.ЕдиницыИзмерения") Тогда
     		СтруктураДанные.Вставить("Коэффициент", СтруктураДанные.ЕдиницаИзмерения.Коэффициент);
		Иначе
			СтруктураДанные.Вставить("Коэффициент", 1);
		КонецЕсли;		
		Цена = УправлениеНебольшойФирмойСервер.ПолучитьЦенуНоменклатурыПоВидуЦен(СтруктураДанные);
		СтруктураДанные.Вставить("Цена", Цена);
	Иначе
		СтруктураДанные.Вставить("Цена", 0);
	КонецЕсли;	
		
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеХарактеристикаПриИзменении()

// Получает набор данных с сервера.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеОрганизацияПриИзменении(Организация)
	
	СтруктураДанные = Новый Структура;
	
	СтруктураДанные.Вставить("Компания", УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(Организация));
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеОрганизацияПриИзменении()

// Получает набор данных с сервера для процедуры ЕдиницаИзмеренияПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеЕдиницаИзмеренияПриИзменении(ТекущаяЕдиницаИзмерения = Неопределено, ЕдиницаИзмерения = Неопределено)
	
	СтруктураДанные = Новый Структура;
	
	Если ТекущаяЕдиницаИзмерения = Неопределено Тогда
		СтруктураДанные.Вставить("ТекущийКоэффициент", 1);
	Иначе
		СтруктураДанные.Вставить("ТекущийКоэффициент", ТекущаяЕдиницаИзмерения.Коэффициент);
	КонецЕсли;
	
	Если ЕдиницаИзмерения = Неопределено Тогда
		СтруктураДанные.Вставить("Коэффициент", 1);
	Иначе
		СтруктураДанные.Вставить("Коэффициент", ЕдиницаИзмерения.Коэффициент);
	КонецЕсли;
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеЕдиницаИзмеренияПриИзменении()

// Получает набор данных с сервера для процедуры СтруктурнаяЕдиницаПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеСтруктурнаяЕдиницаПриИзменении(СтруктурнаяЕдиница)
	
	СтруктураДанные = Новый Структура;
	
	СтруктураДанные.Вставить("РозничныйВидЦен", СтруктурнаяЕдиница.РозничныйВидЦен);
	СтруктураДанные.Вставить("ВалютаЦены", СтруктурнаяЕдиница.РозничныйВидЦен.ВалютаЦены);
	СтруктураДанные.Вставить("СчетУчетаНаценки", СтруктурнаяЕдиница.СчетУчетаНаценки);
			
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеСтруктурнаяЕдиницаПриИзменении()

// ПодключаемоеОборудование
// Процедура получает данные по штрихкодам.
//
&НаСервереБезКонтекста
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
			СтруктураДанныеНоменклатуры.Вставить("Организация", СтруктураДанные.Организация);
			СтруктураДанныеНоменклатуры.Вставить("Номенклатура", ДанныеШтрихкода.Номенклатура);
			СтруктураДанныеНоменклатуры.Вставить("ТипНоменклатуры", ДанныеШтрихкода.Номенклатура.ТипНоменклатуры);
			СтруктураДанныеНоменклатуры.Вставить("Характеристика", ДанныеШтрихкода.Характеристика);
			Если ЗначениеЗаполнено(СтруктураДанные.ВидЦен) Тогда
				СтруктураДанныеНоменклатуры.Вставить("ДатаОбработки", СтруктураДанные.Дата);
				СтруктураДанныеНоменклатуры.Вставить("ВалютаДокумента", СтруктураДанные.ВалютаДокумента);
				СтруктураДанныеНоменклатуры.Вставить("СуммаВключаетНДС", Истина);
				СтруктураДанныеНоменклатуры.Вставить("ВидЦен", СтруктураДанные.ВидЦен);
				Если ЗначениеЗаполнено(ДанныеШтрихкода.ЕдиницаИзмерения)
					И ТипЗнч(ДанныеШтрихкода.ЕдиницаИзмерения) = Тип("СправочникСсылка.ЕдиницыИзмерения") Тогда
					СтруктураДанныеНоменклатуры.Вставить("Коэффициент", ДанныеШтрихкода.ЕдиницаИзмерения.Коэффициент);
				Иначе
					СтруктураДанныеНоменклатуры.Вставить("Коэффициент", 1);
				КонецЕсли;
			КонецЕсли;
			ДанныеШтрихкода.Вставить("СтруктураДанныеНоменклатуры", ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанныеНоменклатуры));
			
			Если НЕ ЗначениеЗаполнено(ДанныеШтрихкода.ЕдиницаИзмерения) Тогда
				ДанныеШтрихкода.ЕдиницаИзмерения  = ДанныеШтрихкода.Номенклатура.ЕдиницаИзмерения;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	СтруктураДанные.Вставить("ДанныеПоШтрихКодам", ДанныеПоШтрихКодам);
	
	Для каждого парам Из Метаданные.Документы.ПереоценкаВРозницеСуммовойУчет.ТабличныеЧасти.Запасы.Реквизиты.Номенклатура.ПараметрыВыбора Цикл
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
	СтруктураДанные.Вставить("Организация", Объект.Организация);
	СтруктураДанные.Вставить("ВидЦен", Объект.ВидЦен);
	СтруктураДанные.Вставить("Дата", Объект.Дата);
	СтруктураДанные.Вставить("ВалютаДокумента", Объект.ВалютаДокумента);
	СтруктураДанные.Вставить("ВалютаДокумента", Объект.ВалютаДокумента);
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
				Если Объект.Запасы.Количество() = 1 
					И НЕ ЗначениеЗаполнено(Объект.Запасы[0].Номенклатура) Тогда
					НоваяСтрока = Объект.Запасы[0];
				Иначе
					НоваяСтрока = Объект.Запасы.Добавить();
				КонецЕсли;
				НоваяСтрока.Номенклатура = ДанныеШтрихкода.Номенклатура;
				НоваяСтрока.Характеристика = ДанныеШтрихкода.Характеристика;
				НоваяСтрока.Партия = ДанныеШтрихкода.Партия;
				НоваяСтрока.Количество = ТекШтрихкод.Количество;
				НоваяСтрока.ЕдиницаИзмерения = ?(ЗначениеЗаполнено(ДанныеШтрихкода.ЕдиницаИзмерения), ДанныеШтрихкода.ЕдиницаИзмерения, ДанныеШтрихкода.СтруктураДанныеНоменклатуры.ЕдиницаИзмерения);
				НоваяСтрока.Цена = ДанныеШтрихкода.СтруктураДанныеНоменклатуры.Цена;
				РассчитатьСуммуВСтрокеТабличнойЧасти(НоваяСтрока);
				Элементы.Запасы.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
			Иначе
				НайденнаяСтрока = МассивСтрокТЧ[0];
				НайденнаяСтрока.Количество = НайденнаяСтрока.Количество + ТекШтрихкод.Количество;
				РассчитатьСуммуВСтрокеТабличнойЧасти(НайденнаяСтрока);
				Элементы.Запасы.ТекущаяСтрока = НайденнаяСтрока.ПолучитьИдентификатор();
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
		
		Оповещение = Новый ОписаниеОповещения("ПолученыШтрихкодыЗавершение", ЭтаФорма, НеизвестныеШтрихкоды);
		
		ОткрытьФорму(
			"РегистрСведений.ШтрихкодыНоменклатуры.Форма.РегистрацияШтрихкодовНоменклатуры",
			Новый Структура("НеизвестныеШтрихкоды", НеизвестныеШтрихкоды), ЭтаФорма,,,,Оповещение
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

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Объект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

#КонецОбласти