﻿
# Область ОбработчикиСлужебные

&НаКлиенте
// Процедура заполнения курса и кратности валюты документа.
//
Процедура ЗаполнитьКурсКратностьВалюты(ЭтоВалютаДокумента)
	
	Если ЭтоВалютаДокумента Тогда
		
		Если ВалютаДокумента = ВалютаРасчетов Тогда
			
			КурсВалютаДокумента = Курс;
			КратностьВалютаДокумента = Кратность;
		
		ИначеЕсли ЗначениеЗаполнено(ВалютаРасчетов) Тогда
			
			МассивКурсКратность = КурсыВалют.НайтиСтроки(Новый Структура("Валюта", ВалютаДокумента));
			
			Если МассивКурсКратность.Количество() > 0 Тогда
				
				КурсВалютаДокумента = МассивКурсКратность[0].Курс;
				КратностьВалютаДокумента = МассивКурсКратность[0].Кратность;
				
			Иначе
				
				КурсВалютаДокумента = 0;
				КратностьВалютаДокумента = 0;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		Если ЗначениеЗаполнено(ВалютаДокумента) Тогда
			
			МассивКурсКратность = КурсыВалют.НайтиСтроки(Новый Структура("Валюта", ВалютаРасчетов));
			
			Если МассивКурсКратность.Количество() > 0 Тогда
				
				Курс = МассивКурсКратность[0].Курс;
				Кратность = МассивКурсКратность[0].Кратность;
				
			Иначе
				
				Курс = 0;
				Кратность = 0;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ВалютаДокумента = ВалютаРасчетов Тогда
			
			КурсВалютаДокумента = Курс;
			КратностьВалютаДокумента = Кратность;
		
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьКурсКратностьВалютыДокумента()

&НаКлиенте
// Процедура проверяет правильность заполнения реквизитов формы.
//
Процедура ПроверитьЗаполнениеРеквизитовФормы(Отказ)
	
	Если НЕ ЗначениеЗаполнено(ВалютаДокумента) Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Не выбрана валюта для заполнения!'");
		Сообщение.Поле = "ВалютаДокумента";
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Курс) Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Обнаружен нулевой курс валюты расчетов!'");
		Сообщение.Поле = "Курс";
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Кратность) Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Обнаружена нулевая кратность курса валюты расчетов!'");
		Сообщение.Поле = "КратностьРасчетов";
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВалютаРасчетов) Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Не выбрана валюта расчетов для заполнения!'");
		Сообщение.Поле = "ВалютаРасчетов";
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеРеквизитовФормы()

&НаКлиенте
// Процедура проверяет модифицированность формы.
//
Функция ПроверитьМодифицированностьФормы()
	
	БылиВнесеныИзменения = Ложь;
	
	Если ПересчитатьЦеныПоВалюте
		ИЛИ (КурсПередИзменением <> Курс)
		ИЛИ (КратностьПередИзменением <> Кратность)
		ИЛИ (КурсВалютаДокументаПередИзменением <> КурсВалютаДокумента)
		ИЛИ (КратностьВалютаДокументаПередИзменением <> КратностьВалютаДокумента)
		ИЛИ (ВалютаРасчетовПередИзменением <> ВалютаРасчетов)
		ИЛИ (ВалютаДокументаПередИзменением <> ВалютаДокумента) Тогда
		
		БылиВнесеныИзменения = Истина;
		
	КонецЕсли; 
	
	Возврат БылиВнесеныИзменения;

КонецФункции // ПроверитьМодифицированностьФормы()

&НаКлиенте
// Управление флагом ПересчитатьЦеныПоВалюте
Процедура УстановитьФлагПересчетаСумм()
	
	Если ЗначениеЗаполнено(ВалютаРасчетов) И ВалютаРасчетовПередИзменением <> ВалютаРасчетов Тогда
		
		ПересчитатьЦеныПоВалюте = Истина;
		
	ИначеЕсли Курс <> КурсПередИзменением Тогда
		
		ПересчитатьЦеныПоВалюте = Истина;
		
	ИначеЕсли Кратность <> КратностьПередИзменением Тогда
		
		ПересчитатьЦеныПоВалюте = Истина;
		
	ИначеЕсли ЗначениеЗаполнено(ВалютаДокумента) И ВалютаДокументаПередИзменением <> ВалютаДокумента Тогда
		
		ПересчитатьЦеныПоВалюте = Истина;
		
	ИначеЕсли КурсВалютаДокумента <> КурсВалютаДокументаПередИзменением Тогда
		
		ПересчитатьЦеныПоВалюте = Истина;
		
	ИначеЕсли КратностьВалютаДокумента <> КратностьВалютаДокументаПередИзменением Тогда
		
		ПересчитатьЦеныПоВалюте = Истина;
		
	Иначе
		
		ПересчитатьЦеныПоВалюте = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
// Процедура заполняет параметры формы.
//
Процедура ПолучитьЗначенияПараметровФормы()
	
	ВалютаДокумента							= Параметры.ВалютаДокумента;
	ВалютаДокументаПередИзменением			= Параметры.ВалютаДокумента;
	КурсВалютаДокумента						= Параметры.КурсВалютаДокумента;
	КурсВалютаДокументаПередИзменением		= Параметры.КурсВалютаДокумента;
	КратностьВалютаДокумента				= Параметры.КратностьВалютаДокумента;
	КратностьВалютаДокументаПередИзменением	= Параметры.КратностьВалютаДокумента;
	
	ВалютаРасчетов							= Параметры.ВалютаРасчетов;
	ВалютаРасчетовПередИзменением			= Параметры.ВалютаРасчетов;
	Курс 									= Параметры.Курс;
	КурсПередИзменением			 			= Параметры.Курс;
	Кратность 								= Параметры.Кратность;
	КратностьПередИзменением 				= Параметры.Кратность;
	
	ДатаДокумента 							= Параметры.ДатаДокумента;
	
КонецПроцедуры // ПолучитьЗначенияПараметровФормы()

&НаСервере
// Процедура заполняет таблицу курсов валют
//
Процедура ЗаполнитьТаблицуКурсовВалют()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаДокумента", ДатаДокумента);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КурсыВалютСрезПоследних.Валюта,
	|	КурсыВалютСрезПоследних.Курс,
	|	КурсыВалютСрезПоследних.Кратность
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних(&ДатаДокумента, ) КАК КурсыВалютСрезПоследних";
	
	ТаблицаРезультатаЗапроса = Запрос.Выполнить().Выгрузить();
	КурсыВалют.Загрузить(ТаблицаРезультатаЗапроса);
	
КонецПроцедуры // ЗаполнитьТаблицуКурсовВалют()

#КонецОбласти

# Область ОбработчикиКоманд

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере формы.
// В процедуре осуществляется
// - инициализация параметров формы.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПолучитьЗначенияПараметровФормы();
	
	ЗаполнитьТаблицуКурсовВалют();
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

# Область ОбработчикиКоманд

&НаКлиенте
// Процедура - обработчик события нажатия кнопки Отмена.
//
Процедура ОтменаВыполнить()
	
	СтруктураВозврата = Новый Структура();
	СтруктураВозврата.Вставить("КодВозвратаДиалога", КодВозвратаДиалога.Отмена);
	СтруктураВозврата.Вставить("БылиВнесеныИзменения", Ложь);
	Закрыть(СтруктураВозврата);

КонецПроцедуры // ОтменаВыполнить()

&НаКлиенте
// Процедура - обработчик события нажатия кнопки ОК.
//
Процедура КнОКВыполнить()
	
	Отказ = Ложь;
	
	ПроверитьЗаполнениеРеквизитовФормы(Отказ);
	Если НЕ Отказ Тогда
		
		БылиВнесеныИзменения = ПроверитьМодифицированностьФормы();
		
		СтруктураВозврата = Новый Структура();
		СтруктураВозврата.Вставить("ИзмененаВалютаДокумента", 	ВалютаДокумента <> ВалютаДокументаПередИзменением ИЛИ КурсВалютаДокумента <> КурсВалютаДокументаПередИзменением ИЛИ КратностьВалютаДокумента <> КратностьВалютаДокументаПередИзменением);
		СтруктураВозврата.Вставить("ВалютаДокумента", 			ВалютаДокумента);
		СтруктураВозврата.Вставить("КурсВалютаДокумента", 		КурсВалютаДокумента);
		СтруктураВозврата.Вставить("КратностьВалютаДокумента",	КратностьВалютаДокумента);
		
		СтруктураВозврата.Вставить("ИзмененаВалютаРасчетов", 	ВалютаРасчетов <> ВалютаРасчетовПередИзменением ИЛИ Курс <> КурсПередИзменением ИЛИ Кратность <> КратностьПередИзменением);
		СтруктураВозврата.Вставить("ВалютаРасчетов", 			ВалютаРасчетов);
		СтруктураВозврата.Вставить("Курс", 						Курс);
		СтруктураВозврата.Вставить("Кратность", 				Кратность);
		
		СтруктураВозврата.Вставить("ПересчитатьЦеныПоВалюте", 	ПересчитатьЦеныПоВалюте);
		
		СтруктураВозврата.Вставить("БылиВнесеныИзменения", 		БылиВнесеныИзменения);
		СтруктураВозврата.Вставить("КодВозвратаДиалога", 		КодВозвратаДиалога.ОК);
		
		Закрыть(СтруктураВозврата);
		
	КонецЕсли;
	
КонецПроцедуры // КнОКВыполнить()

#КонецОбласти

# Область ОбработчикиРеквизитовШапки

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода Валюта.
//
Процедура ВалютаПриИзменении(Элемент)
	
	ЗаполнитьКурсКратностьВалюты(Ложь);
	УстановитьФлагПересчетаСумм();
	
КонецПроцедуры // ВалютаПриИзменении()

&НаКлиенте
Процедура ВалютаДокументаПриИзменении(Элемент)
	
	ЗаполнитьКурсКратностьВалюты(Истина);
	УстановитьФлагПересчетаСумм();
	
КонецПроцедуры

&НаКлиенте
Процедура КурсВалютыРасчетовПриИзменении(Элемент)
	
	УстановитьФлагПересчетаСумм();
	
	Если ВалютаДокумента = ВалютаРасчетов Тогда
		
		КурсВалютаДокумента = Курс;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КратностьВалютыРасчетовПриИзменении(Элемент)
	
	УстановитьФлагПересчетаСумм();
	
	Если ВалютаДокумента = ВалютаРасчетов Тогда
		
		КратностьВалютаДокумента = Кратность;
		
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти