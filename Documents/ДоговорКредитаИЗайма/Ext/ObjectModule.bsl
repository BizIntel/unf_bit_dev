﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытыий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		
		Сотрудник = ДанныеЗаполнения;
		ВидДоговора = Перечисления.ВидыДоговоровКредитаИЗайма.ДоговорЗаймаСотруднику;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("Сотрудник") И 
			ЗначениеЗаполнено(ДанныеЗаполнения.Сотрудник) Тогда
			
			Сотрудник = ДанныеЗаполнения;
			Контрагент = Справочники.Контрагенты.ПустаяСсылка();
			ВидДоговора = Перечисления.ВидыДоговоровКредитаИЗайма.ДоговорЗаймаСотруднику;
			
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("Контрагент") И
			ЗначениеЗаполнено(ДанныеЗаполнения.Контрагент) Тогда
			
			Сотрудник = Справочники.Сотрудники.ПустаяСсылка();
			Контрагент = ДанныеЗаполнения.Контрагент;
			ВидДоговора = Перечисления.ВидыДоговоровКредитаИЗайма.КредитПолученный;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры // ОбработкаЗаполнения()

// Процедура - обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если ВидДоговора = Перечисления.ВидыДоговоровКредитаИЗайма.ДоговорЗаймаСотруднику Тогда
		Контрагент = Неопределено;
	Иначе
		Сотрудник = Неопределено;
		ПогашатьИзЗаработнойПлаты = Ложь;
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события ОбработкаПроведения.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.ДоговорКредитаИЗайма.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	УправлениеНебольшойФирмойСервер.ОтразитьГрафикПогашенияКредитовИЗаймов(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей.
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры // ОбработкаПроведения()

// Процедура - обработчик события ОбработкаПроверкиЗаполнения.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ВидДоговора = Перечисления.ВидыДоговоровКредитаИЗайма.ДоговорЗаймаСотруднику Тогда
		
		УправлениеНебольшойФирмойСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Контрагент");
		Если ПроцентнаяСтавкаГодовая = 0 Тогда
			УправлениеНебольшойФирмойСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "СчетУчетаПроцентов");
		КонецЕсли;
		УправлениеНебольшойФирмойСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "СчетУчетаКомиссии");
		УправлениеНебольшойФирмойСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "ТипКомиссии");
		
	Иначе
		
		УправлениеНебольшойФирмойСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Сотрудник");
		Если ПроцентнаяСтавкаГодовая = 0 Тогда
			УправлениеНебольшойФирмойСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "СчетУчетаПроцентов");
		КонецЕсли;
		Если ТипКомиссии = Перечисления.ТипыКомиссииКредитовИЗаймов.Нет Тогда
			УправлениеНебольшойФирмойСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "СчетУчетаКомиссии");
		КонецЕсли;
		
	КонецЕсли;
	
	Если СчетУчета.ТипСчета <> Перечисления.ТипыСчетов.Расходы И
		СчетУчетаКомиссии.ТипСчета <> Перечисления.ТипыСчетов.Расходы И
		СчетУчетаПроцентов.ТипСчета <> Перечисления.ТипыСчетов.Расходы 
	Тогда
		УправлениеНебольшойФирмойСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "СтруктурнаяЕдиница");
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#КонецЕсли