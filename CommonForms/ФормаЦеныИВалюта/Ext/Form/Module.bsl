﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
// Процедура заполняет параметры формы.
//
Процедура ПолучитьЗначенияПараметровФормы()
	
	КлючПоложения = "";
	
	// Вид цены.
	Если Параметры.Свойство("ВидЦен") Тогда
		
		// Вид цены.
		ВидЦен = Параметры.ВидЦен;
		ВидЦенПриОткрытии = Параметры.ВидЦен;
		ВидЦенЕстьРеквизит = Истина;
		
		КлючПоложения = КлючПоложения + "ВидЦен";
		
	Иначе
		
		// Доступность вида цены.
		Элементы.ВидЦен.Видимость = Ложь;
		ВидЦенЕстьРеквизит = Ложь;
		
		Элементы.ВидСкидки.Видимость = Ложь;
		ВидСкидкиЕстьРеквизит = Ложь;
		
	КонецЕсли;
	
	Если Параметры.Свойство("ДоступностьВалютыДокумента") Тогда
		
		Элементы.Валюта.Доступность = Параметры.ДоступностьВалютыДокумента;
		Элементы.ПересчитатьЦены.Видимость = Параметры.ДоступностьВалютыДокумента;
		
	КонецЕсли;
	
	// Вид цены контрагента.
	Если Параметры.Свойство("ВидЦенКонтрагента") Тогда
		
		// Вид цены.
		ВидЦенКонтрагента = Параметры.ВидЦенКонтрагента;
		ВидЦенКонтрагентаПриОткрытии = Параметры.ВидЦенКонтрагента;
		Контрагент = Параметры.Контрагент;
		ВидЦенКонтрагентаЕстьРеквизит = Истина;
		
		МассивЗначений = Новый Массив;
		МассивЗначений.Добавить(Контрагент);
		МассивЗначений = Новый ФиксированныйМассив(МассивЗначений);
		НовыйПараметр = Новый ПараметрВыбора("Отбор.Владелец", МассивЗначений);
		НовыйМассив = Новый Массив();
		НовыйМассив.Добавить(НовыйПараметр);
		НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
		Элементы.ВидЦенКонтрагента.ПараметрыВыбора = НовыеПараметры;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПерезаполнитьЦены", "Видимость", ПолучитьФункциональнуюОпцию("УчетЦенКонтрагентов"));
		КлючПоложения = КлючПоложения + "ВидЦенКонтрагента";
		
	Иначе
		
		// Доступность вида цены контрагента.
		Элементы.ВидЦенКонтрагента.Видимость = Ложь;
		ВидЦенКонтрагентаЕстьРеквизит = Ложь;
		
	КонецЕсли;
	
	// РегистрироватьЦеныПоставщика.
	Если Параметры.Свойство("РегистрироватьЦеныПоставщика") Тогда
		
		РегистрироватьЦеныПоставщика = Параметры.РегистрироватьЦеныПоставщика;
		РегистрироватьЦеныПоставщикаПриОткрытии = Параметры.РегистрироватьЦеныПоставщика;
		РегистрироватьЦеныПоставщикаЕстьРеквизит = Истина;
		
		КлючПоложения = КлючПоложения + "РегистрироватьЦеныПоставщика";
		
	Иначе
		
		// Доступность.
		Элементы.РегистрироватьЦеныПоставщика.Видимость = Ложь;
		РегистрироватьЦеныПоставщикаЕстьРеквизит = Ложь;
		
	КонецЕсли;
	
	// Флаг - перезаполнить цены.
	Если НЕ (ВидЦенЕстьРеквизит ИЛИ ВидЦенКонтрагентаЕстьРеквизит) Тогда
		
		Элементы.ПерезаполнитьЦены.Видимость = Ложь;
		КлючПоложения = КлючПоложения + "НеПерезаполнятьЦены";
		
	КонецЕсли; 
	
	// Скидки.
	Если Параметры.Свойство("ВидСкидки") Тогда
		
		ВидСкидки = Параметры.ВидСкидки;
		ВидСкидкиПриОткрытии = Параметры.ВидСкидки;
		ВидСкидкиЕстьРеквизит = Истина;
		
		КлючПоложения = КлючПоложения + "ВидСкидки";
		
	Иначе
		
		Элементы.ВидСкидки.Видимость = Ложь;
		ВидСкидкиЕстьРеквизит = Ложь;
		
	КонецЕсли;
	
	// Дисконтные карты.
	Если Параметры.Свойство("ДисконтнаяКарта") Тогда
		
		ДисконтнаяКарта = Параметры.ДисконтнаяКарта;
		ДисконтнаяКартаПриОткрытии = Параметры.ДисконтнаяКарта;
		ДисконтнаяКартаЕстьРеквизит = Истина;
		Если Параметры.Свойство("Контрагент") Тогда
			Контрагент = Параметры.Контрагент;
		КонецЕсли;
		Элементы.ДисконтнаяКарта.Видимость = Истина;
		ДисконтнаяКартаЕстьРеквизит = Истина;
		
		КлючПоложения = КлючПоложения + "ДисконтнаяКарта";
		
	Иначе
		
		Элементы.ДисконтнаяКарта.Видимость = Ложь;
		ДисконтнаяКартаЕстьРеквизит = Ложь;
		
	КонецЕсли;
	
	// Валюта документа.
	Если Параметры.Свойство("ВалютаДокумента") Тогда
		
		ВалютаДокумента = Параметры.ВалютаДокумента;
		ВалютаДокументаПриОткрытии = Параметры.ВалютаДокумента;
		ВалютаДокументаЕстьРеквизит = Истина;
		
		КлючПоложения = КлючПоложения + "ВалютаДокумента";
		
	Иначе
		
		Элементы.ВалютаДокумента.Видимость = Ложь;
		Элементы.Курс.Видимость = Ложь;
		Элементы.Кратность.Видимость = Ложь;
		Элементы.ПересчитатьЦены.Видимость = Ложь;
		ВалютаДокументаЕстьРеквизит = Ложь;
		
	КонецЕсли;
	
	// Налогообложение НДС.
	Если Параметры.Свойство("НалогообложениеНДС") Тогда
		
		НалогообложениеНДС = Параметры.НалогообложениеНДС;
		НалогообложениеНДСПриОткрытии = Параметры.НалогообложениеНДС;
		НалогообложениеНДСЕстьРеквизит = Истина;
		
		КлючПоложения = КлючПоложения + "НалогообложениеНДС";
		
	Иначе
		
		Элементы.НалогообложениеНДС.Видимость = Ложь;
		НалогообложениеНДСЕстьРеквизит = Ложь;
		
	КонецЕсли;
	
	// Сумма включает НДС.
	Если Параметры.Свойство("СуммаВключаетНДС") Тогда
		
		СуммаВключаетНДС = Параметры.СуммаВключаетНДС;
		СуммаВключаетНДСПриОткрытии = Параметры.СуммаВключаетНДС;
		СуммаВключаетНДСЕстьРеквизит = Истина;
		
		КлючПоложения = КлючПоложения + "СуммаВключаетНДС";
		
	Иначе
		
		Элементы.СуммаВключаетНДС.Видимость = Ложь;
		СуммаВключаетНДСЕстьРеквизит = Ложь;
		
	КонецЕсли;	
	
	// НДС включать в стоимость.
	Если Параметры.Свойство("НДСВключатьВСтоимость") Тогда
		
		НДСВключатьВСтоимость = Параметры.НДСВключатьВСтоимость;
		НДСВключатьВСтоимостьПриОткрытии = Параметры.НДСВключатьВСтоимость;
		НДСВключатьВСтоимостьЕстьРеквизит = Истина;
		
		КлючПоложения = КлючПоложения + "НДСВключатьВСтоимость";
		
	Иначе
		
		Элементы.НДСВключатьВСтоимость.Видимость = Ложь;
		НДСВключатьВСтоимостьЕстьРеквизит = Ложь;
		
	КонецЕсли;
		
	// Валюта расчетов.
	Если Параметры.Свойство("Договор") Тогда
		
		ВалютаРасчетов	  = Параметры.Договор.ВалютаРасчетов;
		РасчетыВУЕ		  = Параметры.Договор.РасчетыВУсловныхЕдиницах;
		КурсРасчетов 	  = Параметры.Курс;
		КратностьРасчетов = Параметры.Кратность;
		
		КурсРасчетовПриОткрытии 	 = Параметры.Курс;
		КратностьРасчетовПриОткрытии = Параметры.Кратность;
		
		ДоговорЕстьРеквизит = Истина;
		
		КлючПоложения = КлючПоложения + "Договор";
		
		Если Параметры.Свойство("ЭтоСчетФактура") Тогда
			
			Элементы.ВалютаРасчетов.Видимость = Ложь;
			Элементы.КурсРасчетов.Видимость = Ложь;
			Элементы.КратностьРасчетов.Видимость = Ложь;
			
			КлючПоложения = КлючПоложения + "ЭтоСчетФактура";
			
		КонецЕсли;
		
	Иначе
		
		Элементы.ВалютаРасчетов.Видимость = Ложь;
		Элементы.КурсРасчетов.Видимость = Ложь;
		Элементы.КратностьРасчетов.Видимость = Ложь;
		
		ДоговорЕстьРеквизит = Ложь;
		
	КонецЕсли;
	
	ПерезаполнитьЦены = Параметры.ПерезаполнитьЦены;
	ПересчитатьЦены   = Параметры.ПересчитатьЦены;
		
	Если ЗначениеЗаполнено(ВалютаДокумента) Тогда
		МассивКурсКратность = КурсыВалют.НайтиСтроки(Новый Структура("Валюта", ВалютаДокумента));
		Если ВалютаДокумента = ВалютаРасчетов
		   И КурсРасчетов <> 0
		   И КратностьРасчетов <> 0 Тогда
			Курс = КурсРасчетов;
			Кратность = КратностьРасчетов;
		Иначе
			Если ЗначениеЗаполнено(МассивКурсКратность) Тогда
				Курс = МассивКурсКратность[0].Курс;
				Кратность = МассивКурсКратность[0].Кратность;
			Иначе
				Курс = 0;
				Кратность = 0;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Хеш = Новый ХешированиеДанных(ХешФункция.MD5);
	Хеш.Добавить(КлючПоложения);
	ЭтотОбъект.КлючСохраненияПоложенияОкна = "ЦеныИВалюта" + СтрЗаменить(Хеш.ХешСумма, " ", "");
	
КонецПроцедуры // ПолучитьЗначенияПараметровФормы()

&НаСервере
// Процедура заполняет таблицу курсов валют
//
Процедура ЗаполнитьТаблицуКурсовВалют()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаДокумента", Параметры.ДатаДокумента);
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

&НаКлиенте
// Процедура проверяет правильность заполнения реквизитов формы.
//
Процедура ПроверитьЗаполнениеРеквизитовФормы(Отказ, НеЗаполненТолькоВидЦен = Ложь)
    	
	// Проверка заполненности реквизитов.
	
	// ДисконтныеКарты
	НеЗаполненТолькоВидЦен = Истина;
	// Конец ДисконтныеКарты
	
	// Вид цен контрагента.
	Если (ПерезаполнитьЦены ИЛИ РегистрироватьЦеныПоставщика) И ВидЦенКонтрагентаЕстьРеквизит Тогда
		Если НЕ ЗначениеЗаполнено(ВидЦенКонтрагента) Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = НСтр("ru = 'Не выбран вид цен контрагента для заполнения!'");
			Сообщение.Поле = "ВидЦенКонтрагента";
			Сообщение.Сообщить();
  			Отказ = Истина;
			НеЗаполненТолькоВидЦен = Ложь; // ДисконтныеКарты
    	КонецЕсли;
	КонецЕсли;
	
	// Валюта документа.
	Если ВалютаДокументаЕстьРеквизит Тогда
		Если НЕ ЗначениеЗаполнено(ВалютаДокумента) Тогда
            Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = НСтр("ru = 'Не заполнена валюта документа!'");
			Сообщение.Поле = "ВалютаДокумента";
			Сообщение.Сообщить();
			Отказ = Истина;
			НеЗаполненТолькоВидЦен = Ложь; // ДисконтныеКарты
   		КонецЕсли;
	КонецЕсли;
	
	// Налогообложение НДС.
	Если НалогообложениеНДСЕстьРеквизит Тогда
		Если НЕ ЗначениеЗаполнено(НалогообложениеНДС) Тогда
            Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = НСтр("ru = 'Не заполнено налогообложение!'");
			Сообщение.Поле = "НалогообложениеНДС";
			Сообщение.Сообщить();
			Отказ = Истина;
			НеЗаполненТолькоВидЦен = Ложь; // ДисконтныеКарты
   		КонецЕсли;
	КонецЕсли;
	
	// Расчеты.
	Если ДоговорЕстьРеквизит Тогда
		Если НЕ ЗначениеЗаполнено(КурсРасчетов) Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = НСтр("ru = 'Обнаружен нулевой курс валюты расчетов!'");
			Сообщение.Поле = "КурсРасчетов";
			Сообщение.Сообщить();
			Отказ = Истина;
			НеЗаполненТолькоВидЦен = Ложь; // ДисконтныеКарты
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(КратностьРасчетов) Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = НСтр("ru = 'Обнаружена нулевая кратность курса валюты расчетов!'");
			Сообщение.Поле = "КратностьРасчетов";
			Сообщение.Сообщить();
			Отказ = Истина;
			НеЗаполненТолькоВидЦен = Ложь; // ДисконтныеКарты
		КонецЕсли;
	КонецЕсли;
	
	// Вид цен.
	Если ПерезаполнитьЦены И ВидЦенЕстьРеквизит Тогда
		Если НЕ ЗначениеЗаполнено(ВидЦен) Тогда
			Если ВидСкидки.Пустая() И Не ДисконтнаяКарта.Пустая() И НеЗаполненТолькоВидЦен Тогда // ДисконтныеКарты
				// Можно в документе пересчитать скидки по дисконтной карте.
			Иначе
				Сообщение = Новый СообщениеПользователю();
				Сообщение.Текст = НСтр("ru = 'Не выбран вид цены для заполнения!'");
				Сообщение.Поле = "ВидЦен";
				Сообщение.Сообщить();
				НеЗаполненТолькоВидЦен = Ложь;
			КонецЕсли;
			Отказ = Истина;
    	КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеРеквизитовФормы()

&НаКлиенте
// Процедура проверяет модифицированность формы.
//
Процедура ПроверитьМодифицированностьФормы()

	БылиВнесеныИзменения = Ложь;
	
	ИзмененияВидЦен 				= ?(ВидЦенЕстьРеквизит, ВидЦенПриОткрытии <> ВидЦен, Ложь);
	ИзмененияВидЦенКонтрагента 		= ?(ВидЦенКонтрагентаЕстьРеквизит, ВидЦенКонтрагентаПриОткрытии <> ВидЦенКонтрагента, Ложь);
	ИзмененияРегистрироватьЦеныПоставщика = ?(РегистрироватьЦеныПоставщикаЕстьРеквизит, РегистрироватьЦеныПоставщикаПриОткрытии <> РегистрироватьЦеныПоставщика, Ложь);
	ИзмененияВидСкидки 				= ?(ВидСкидкиЕстьРеквизит, ВидСкидкиПриОткрытии <> ВидСкидки, Ложь);
	ИзмененияВалютаДокумента 		= ?(ВалютаДокументаЕстьРеквизит, ВалютаДокументаПриОткрытии <> ВалютаДокумента, Ложь);
	ИзмененияНалогообложениеНДС 	= ?(НалогообложениеНДСЕстьРеквизит, НалогообложениеНДСПриОткрытии <> НалогообложениеНДС, Ложь);
	ИзмененияСуммаВключаетНДС 		= ?(СуммаВключаетНДСЕстьРеквизит, СуммаВключаетНДСПриОткрытии <> СуммаВключаетНДС, Ложь);
	ИзмененияНДСВключатьВСтоимость 	= ?(НДСВключатьВСтоимостьЕстьРеквизит, НДСВключатьВСтоимостьПриОткрытии <> НДСВключатьВСтоимость, Ложь);
    ИзмененияКурсРасчетов 			= ?(ДоговорЕстьРеквизит, КурсРасчетовПриОткрытии <> КурсРасчетов, Ложь);
    ИзмененияКратностьРасчетов 		= ?(ДоговорЕстьРеквизит, КратностьРасчетовПриОткрытии <> КратностьРасчетов, Ложь);
    ИзмененияДисконтнаяКарта		= ?(ДисконтнаяКартаЕстьРеквизит, ДисконтнаяКартаПриОткрытии <> ДисконтнаяКарта, Ложь); // ДисконтныеКарты
	
	Если ПерезаполнитьЦены
	 ИЛИ ПересчитатьЦены
	 ИЛИ ИзмененияВалютаДокумента
	 ИЛИ ИзмененияНалогообложениеНДС
     ИЛИ ИзмененияСуммаВключаетНДС
	 ИЛИ ИзмененияНДСВключатьВСтоимость
	 ИЛИ ИзмененияКурсРасчетов
	 ИЛИ ИзмененияКратностьРасчетов
	 ИЛИ ИзмененияВидЦен
	 ИЛИ ИзмененияВидЦенКонтрагента
	 ИЛИ ИзмененияРегистрироватьЦеныПоставщика
	 ИЛИ ИзмененияДисконтнаяКарта // ДисконтныеКарты
	 ИЛИ ИзмененияВидСкидки Тогда	

		БылиВнесеныИзменения = Истина;

	КонецЕсли;
	
КонецПроцедуры // ПроверитьМодифицированностьФормы()

&НаКлиенте
// Процедура заполнения курса и кратности валюты документа.
//
Процедура ЗаполнитьКурсКратностьВалютыДокумента()
	
	Если ЗначениеЗаполнено(ВалютаДокумента) Тогда
		МассивКурсКратность = КурсыВалют.НайтиСтроки(Новый Структура("Валюта", ВалютаДокумента));
		Если ВалютаДокумента = ВалютаРасчетов
		   И КурсРасчетов <> 0
		   И КратностьРасчетов <> 0 Тогда
			Курс = КурсРасчетов;
			Кратность = КратностьРасчетов;
		Иначе
			Если ЗначениеЗаполнено(МассивКурсКратность) Тогда
				Курс = МассивКурсКратность[0].Курс;
				Кратность = МассивКурсКратность[0].Кратность;
			Иначе
				Курс = 0;
				Кратность = 0;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьКурсКратностьВалютыДокумента()

#Область ДисконтныеКарты

// Функция возвращает владельца дисконтной карты.
//
&НаСервереБезКонтекста
Функция ПолучитьВладельцаКарты(ДисконтнаяКарта)

	Возврат ДисконтнаяКарта.ВладелецКарты;

КонецФункции // ПолучитьВладельцаКарты()

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере формы.
// В процедуре осуществляется
// - инициализация параметров формы.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВалютаУчета = Константы.НациональнаяВалюта.Получить();
	ЗаполнитьТаблицуКурсовВалют();
	ПолучитьЗначенияПараметровФормы();
	
	Если ДоговорЕстьРеквизит Тогда	
		НовыйМассив = Новый Массив();
		Если РасчетыВУЕ
		   И ВалютаУчета <> ВалютаРасчетов Тогда
			НовыйМассив.Добавить(ВалютаУчета);
		КонецЕсли;
		НовыйМассив.Добавить(ВалютаРасчетов);
		НовыйПараметр = Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(НовыйМассив));
		НовыйМассив2 = Новый Массив();
		НовыйМассив2.Добавить(НовыйПараметр);
		НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив2);
		Элементы.Валюта.ПараметрыВыбора = НовыеПараметры;
	КонецЕсли;
	
	Параметры.Свойство("ТекстПредупреждения", ТекстПредупреждения);
	Если ПустаяСтрока(ТекстПредупреждения) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаПредупреждение", "Видимость", Ложь);
		
	КонецЕсли;
	Элементы.Предупреждение.Заголовок = ТекстПредупреждения;
	
	// ДисконтныеКарты
	Параметры.Свойство("ДатаДокумента", ДатаДокумента);
	НастроитьНадписьПоДисконтнойКарте();
	
КонецПроцедуры // ПриСозданииНаСервере()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

&НаКлиенте
// Процедура - обработчик события нажатия кнопки ОК.
//
Процедура КомандаОК(Команда)
	
	Отказ = Ложь;
	НеЗаполненТолькоВидЦенИЗаполненаКарта = Ложь; // ДисконтныеКарты

	ПроверитьЗаполнениеРеквизитовФормы(Отказ, НеЗаполненТолькоВидЦенИЗаполненаКарта);
	ПроверитьМодифицированностьФормы();
    
	Если НЕ Отказ ИЛИ НеЗаполненТолькоВидЦенИЗаполненаКарта Тогда

		СтруктураРеквизитовФормы = Новый Структура;

        СтруктураРеквизитовФормы.Вставить("БылиВнесеныИзменения", 			БылиВнесеныИзменения);

        СтруктураРеквизитовФормы.Вставить("ВидЦен", 						ВидЦен);
		СтруктураРеквизитовФормы.Вставить("ВидЦенКонтрагента", 				ВидЦенКонтрагента);
		СтруктураРеквизитовФормы.Вставить("РегистрироватьЦеныПоставщика", 	РегистрироватьЦеныПоставщика);
		СтруктураРеквизитовФормы.Вставить("ВидСкидки",  					ВидСкидки);

		СтруктураРеквизитовФормы.Вставить("ВалютаДокумента", 				ВалютаДокумента);
		СтруктураРеквизитовФормы.Вставить("НалогообложениеНДС",				НалогообложениеНДС);
		СтруктураРеквизитовФормы.Вставить("СуммаВключаетНДС", 				СуммаВключаетНДС);
		СтруктураРеквизитовФормы.Вставить("НДСВключатьВСтоимость", 			НДСВключатьВСтоимость);

		СтруктураРеквизитовФормы.Вставить("ВалютаРасчетов", 				ВалютаРасчетов);
		СтруктураРеквизитовФормы.Вставить("Курс", 							Курс);
		СтруктураРеквизитовФормы.Вставить("КурсРасчетов", 					КурсРасчетов);
		СтруктураРеквизитовФормы.Вставить("Кратность", 						Кратность);
        СтруктураРеквизитовФормы.Вставить("КратностьРасчетов", 				КратностьРасчетов);
                         
		СтруктураРеквизитовФормы.Вставить("ПредВалютаДокумента", 			ВалютаДокументаПриОткрытии);
		СтруктураРеквизитовФормы.Вставить("ПредНалогообложениеНДС", 		НалогообложениеНДСПриОткрытии);
		СтруктураРеквизитовФормы.Вставить("ПредСуммаВключаетНДС", 			СуммаВключаетНДСПриОткрытии);

        СтруктураРеквизитовФормы.Вставить("ПерезаполнитьЦены", 				ПерезаполнитьЦены И Не Отказ);
        СтруктураРеквизитовФормы.Вставить("ПересчитатьЦены", 				ПересчитатьЦены);

		СтруктураРеквизитовФормы.Вставить("ИмяФормы", 						"ОбщаяФорма.ФормаВалюта");

		// ДисконтныеКарты
		СтруктураРеквизитовФормы.Вставить("ПерезаполнитьСкидки",			ПерезаполнитьЦены И НеЗаполненТолькоВидЦенИЗаполненаКарта);
		СтруктураРеквизитовФормы.Вставить("ДисконтнаяКарта",  				ДисконтнаяКарта);
		СтруктураРеквизитовФормы.Вставить("ПроцентСкидкиПоДисконтнойКарте",	ПроцентСкидкиПоДисконтнойКарте);
		СтруктураРеквизитовФормы.Вставить("Контрагент",						ПолучитьВладельцаКарты(ДисконтнаяКарта));
		// Конец ДисконтныеКарты
		
		Закрыть(СтруктураРеквизитовФормы);

	КонецЕсли;
	
КонецПроцедуры // КомандаОК()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ФОРМЫ

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода ВидЦен.
//
Процедура ВидЦеныПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ВидЦен) Тогда
                        
        Если ВидЦенПриОткрытии <> ВидЦен Тогда
			
			ПерезаполнитьЦены = Истина;

		КонецЕсли;
        
	КонецЕсли;
	
КонецПроцедуры // ВидЦеныПриИзменении()

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода ВидЦенКонтрагента.
//
Процедура ВидЦенКонтрагентаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ВидЦенКонтрагента) Тогда
                        
        Если ВидЦенКонтрагентаПриОткрытии <> ВидЦенКонтрагента Тогда
			
			ПерезаполнитьЦены = Истина;

		КонецЕсли;
        
	КонецЕсли;
	
КонецПроцедуры // ВидЦеныПриИзменении()

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода ВидСкидки.
//
Процедура ВидСкидкиПриИзменении(Элемент)
	
	Если ВидСкидкиПриОткрытии <> ВидСкидки Тогда
		ПерезаполнитьЦены = Истина;
	КонецЕсли;
	
КонецПроцедуры // ВидСкидкиПриИзменении()

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода Валюта.
//
Процедура ВалютаПриИзменении(Элемент)
	
	ЗаполнитьКурсКратностьВалютыДокумента();

	Если ЗначениеЗаполнено(ВалютаДокумента)
		
	   И ВалютаДокументаПриОткрытии <> ВалютаДокумента Тогда
  		ПересчитатьЦены = Истина;
		
  	КонецЕсли;

КонецПроцедуры // ВалютаПриИзменении()

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода ВалютаРасчетов.
//
Процедура ВалютаРасчетовПриИзменении(Элемент)
	
	ЗаполнитьКурсКратностьВалютыДокумента();

КонецПроцедуры // ВалютаРасчетовПриИзменении()

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода КурсРасчетов.
//
Процедура КурсРасчетовПриИзменении(Элемент)
	
	ЗаполнитьКурсКратностьВалютыДокумента();

КонецПроцедуры // КурсРасчетовПриИзменении()

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода КратностьРасчетов.
//
Процедура КратностьРасчетовПриИзменении(Элемент)
	
	ЗаполнитьКурсКратностьВалютыДокумента();

КонецПроцедуры // КратностьРасчетовПриИзменении()

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода ПерезаполнитьЦены.
//
Процедура ПерезаполнитьЦеныПриИзменении(Элемент)
	
	Если ВидЦенЕстьРеквизит Тогда
		
		Если ПерезаполнитьЦены Тогда
			Если ВидСкидки.Пустая() И Не ДисконтнаяКарта.Пустая() Тогда // ДисконтныеКарты
				Элементы.ВидЦен.АвтоОтметкаНезаполненного = Ложь;
			Иначе
				Элементы.ВидЦен.АвтоОтметкаНезаполненного = Истина;
			КонецЕсли;
		Иначе	
			Элементы.ВидЦен.АвтоОтметкаНезаполненного = Ложь;
			ОтключитьОтметкуНезаполненного();
		КонецЕсли;		
	
	ИначеЕсли ВидЦенКонтрагентаЕстьРеквизит Тогда
		
		Если ПерезаполнитьЦены ИЛИ РегистрироватьЦеныПоставщика Тогда
			Элементы.ВидЦенКонтрагента.АвтоОтметкаНезаполненного = Истина;
		Иначе	
			Элементы.ВидЦенКонтрагента.АвтоОтметкаНезаполненного = Ложь;
			ОтключитьОтметкуНезаполненного();
		КонецЕсли;		
	
	КонецЕсли;
	
КонецПроцедуры // ПерезаполнитьЦеныПриИзменении()

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода РегистрироватьЦеныПоставщика.
//
Процедура РегистрироватьЦеныПоставщикаПриИзменении(Элемент)
	
	Если РегистрироватьЦеныПоставщика ИЛИ ПерезаполнитьЦены Тогда
		Элементы.ВидЦенКонтрагента.АвтоОтметкаНезаполненного = Истина;
	Иначе	
		Элементы.ВидЦенКонтрагента.АвтоОтметкаНезаполненного = Ложь;
		ОтключитьОтметкуНезаполненного();
	КонецЕсли;
	
КонецПроцедуры // ПерезаполнитьЦеныПриИзменении()

#Область ДисконтныеКарты

// Процедура - обработчик события НачалоВыбора элемента ДисконтнаяКарта формы.
//
&НаКлиенте
Процедура ДисконтнаяКартаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФормуВыбораДисконтнойКартыЗавершение", ЭтотОбъект); //, Новый Структура("Отбор", СтруктураОтбора));
	ОткрытьФорму("Справочник.ДисконтныеКарты.ФормаВыбора", Новый Структура("Контрагент, ОтборПоКонтрагенту", Контрагент, Истина), ЭтаФорма.ДисконтнаяКарта, ЭтаФорма.УникальныйИдентификатор, , , ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// Процедура вызывается после выбора дисконтной карты из формы выбора справочника ДисконтныеКарты.
//
&НаКлиенте
Процедура ОткрытьФормуВыбораДисконтнойКартыЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт

	Если ЗначениеЗаполнено(РезультатЗакрытия) Тогда 
		ДисконтнаяКарта = РезультатЗакрытия;
	
		Если ДисконтнаяКартаПриОткрытии <> ДисконтнаяКарта Тогда
			
			ПерезаполнитьЦены = Истина;
			
		КонецЕсли;
	КонецЕсли;

	// Мог измениться % накопительной скидки, т.ч. обновляем надпись, даже если дисконтная карта не поменялась.
	НастроитьНадписьПоДисконтнойКарте();
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении элемента ДисконтнаяКарта формы.
//
&НаКлиенте
Процедура ДисконтнаяКартаПриИзменении(Элемент)
	
	Если ДисконтнаяКартаПриОткрытии <> ДисконтнаяКарта Тогда
		
		ПерезаполнитьЦены = Истина;
		
	КонецЕсли;
	
	// Мог измениться % накопительной скидки, т.ч. обновляем надпись, даже если дисконтная карта не поменялась.
	НастроитьНадписьПоДисконтнойКарте();
	
	ПерезаполнитьЦеныПриИзменении(Элементы.ПерезаполнитьЦены);
	
КонецПроцедуры

// Процедура заполняет подсказку дисконтной карты информацией о скидке по дисконтной карте.
//
&НаСервере
Процедура НастроитьНадписьПоДисконтнойКарте()
	
	Если Не ДисконтнаяКарта.Пустая() Тогда
		Если Не Контрагент.Пустая() И ДисконтнаяКарта.Владелец.ЭтоИменнаяКарта И ДисконтнаяКарта.ВладелецКарты <> Контрагент Тогда
			
			ДисконтнаяКарта = Справочники.ДисконтныеКарты.ПустаяСсылка();
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Владелец дисконтной карты не совпадает с контрагентом в документе.";
			Сообщение.Поле = "ДисконтнаяКарта";
			Сообщение.Сообщить();
			
		КонецЕсли;
	КонецЕсли;
	
	Если ДисконтнаяКарта.Пустая() Тогда
		ПроцентСкидкиПоДисконтнойКарте = 0;
		Элементы.ДисконтнаяКарта.Подсказка = "";
	Иначе
		ПроцентСкидкиПоДисконтнойКарте = УправлениеНебольшойФирмойСервер.ВычислитьПроцентСкидкиПоДисконтнойКарте(ДатаДокумента, ДисконтнаяКарта);		
		Элементы.ДисконтнаяКарта.Подсказка = "Скидка по карте составляет "+ПроцентСкидкиПоДисконтнойКарте+"%";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти