﻿
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	ИнтеграцияЕГАИСВызовСервера.ПриПолученииФормыДокумента(
		"ТТНВходящаяЕГАИС",
		ВидФормы,
		Параметры,
		ВыбраннаяФорма,
		ДополнительнаяИнформация,
		СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Осуществляет поиск ТТН по идентификатору ЕГАИС.
//
// Параметры:
//  ИдентификаторЕГАИС - Строка - идентификатор ТТН в системе ЕГАИС.
//
// Возвращаемое значение:
//   ДокументСсылка.ТТНВходящаяЕГАИС - найденная ТТН. Неопределено - если не найдена.
//
Функция ТТНПоИдентификатору(ИдентификаторЕГАИС) Экспорт
	Перем Результат;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТТНВходящаяЕГАИС.Ссылка КАК ТТН
	|ИЗ
	|	Документ.ТТНВходящаяЕГАИС КАК ТТНВходящаяЕГАИС
	|ГДЕ
	|	ТТНВходящаяЕГАИС.ИдентификаторЕГАИС = &ИдентификаторЕГАИС";
	
	Запрос.УстановитьПараметр("ИдентификаторЕГАИС", ИдентификаторЕГАИС);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат = Выборка.ТТН;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает данные ТТН в виде структуры перед выгрузкой в УТМ.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ТТНВходящаяЕГАИС - выгружаемая ТТН,
//  ВидДокумента - ПеречислениеСсылка.ВидыДокументовЕГАИС - вид выгружаемого документа.
//
// Возвращаемое значение:
//   Структура - данные ТТН.
//
Функция ИнициализироватьДанныеДокументаДляВыгрузки(ДокументСсылка, ВидДокумента) Экспорт

	Если ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктПодтвержденияТТН Тогда
		Возврат ИнициализироватьДанныеАктаПодтвержденияТТН(ДокументСсылка);
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктОтказаОтТТН Тогда
		Возврат ИнициализироватьДанныеАктаОтказаОтТТН(ДокументСсылка);
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктРасхожденийТТН Тогда
		Возврат ИнициализироватьДанныеАктаРасхожденийТТН(ДокументСсылка);
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросНаОтменуПроведенияТТН Тогда
		Возврат ИнициализироватьДанныеЗапросаНаОтменуПроведенияТТН(ДокументСсылка);
		
	Иначе
		ТекстОшибки = НСтр("ru='Неподдерживаемый вид документа %1 для входящей ТТН'");
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ВидДокумента);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
КонецФункции

// Добавляет на форму списка условное оформление состояния фиксации.
//
//  Параметры:
//   Форма - УправляемаяФорма – форма документа.
//   ОформляемоеПоле - Строка – имя поля для оформления.
//   ПутьКДанным - Строка - путь к реквизиту СтатусОбработки.
//
Процедура УстановитьУсловноеОформлениеСтатусаОбработки(Форма, ОформляемоеПоле = "Список", ПутьКДанным = "Список.СтатусОбработки") Экспорт
	
	УсловноеОформлениеКД = Форма.УсловноеОформление;
	
	// Представление статуса Передается
	СписокСтатусов = Новый СписокЗначений;
	СписокСтатусов.Добавить(Перечисления.СтатусыОбработкиТТНВходящейЕГАИС.ПередаетсяАктПодтверждения);
	СписокСтатусов.Добавить(Перечисления.СтатусыОбработкиТТНВходящейЕГАИС.ПередаетсяАктОтказа);
	СписокСтатусов.Добавить(Перечисления.СтатусыОбработкиТТНВходящейЕГАИС.ПередаетсяАктРасхождений);
	СписокСтатусов.Добавить(Перечисления.СтатусыОбработкиТТНВходящейЕГАИС.ПередаетсяЗапросНаОтменуПроведения);
	
	ПредставлениеЭлемента = НСтр("ru = 'Документ передается в ЕГАИС'");
	
	ЭлементУсловногоОформления = УсловноеОформлениеКД.Элементы.Добавить();
	ЭлементУсловногоОформления.Представление = ПредставлениеЭлемента;
	ЭлементУсловногоОформления.Использование = Истина;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЕГАИССтатусОбработкиПередается);
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ОформляемоеПоле);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ЭлементУсловногоОформления.Отбор,
		ПутьКДанным,
		СписокСтатусов,
		ВидСравненияКомпоновкиДанных.ВСписке,
		ПредставлениеЭлемента,
		Истина);
	
	// Представление статуса ОшибкаПередачи
	СписокСтатусов = Новый СписокЗначений;
	СписокСтатусов.Добавить(Перечисления.СтатусыОбработкиТТНВходящейЕГАИС.ОшибкаПередачиАктаПодтверждения);
	СписокСтатусов.Добавить(Перечисления.СтатусыОбработкиТТНВходящейЕГАИС.ОшибкаПередачиАктаОтказа);
	СписокСтатусов.Добавить(Перечисления.СтатусыОбработкиТТНВходящейЕГАИС.ОшибкаПередачиАктаРасхождений);
	СписокСтатусов.Добавить(Перечисления.СтатусыОбработкиТТНВходящейЕГАИС.ОшибкаПередачиЗапросаНаОтменуПроведения);
	
	ПредставлениеЭлемента = НСтр("ru = 'Получена ошибка передачи в ЕГАИС'");
	
	ЭлементУсловногоОформления = УсловноеОформлениеКД.Элементы.Добавить();
	ЭлементУсловногоОформления.Представление = ПредставлениеЭлемента;
	ЭлементУсловногоОформления.Использование = Истина;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЕГАИССтатусОбработкиОшибкаПередачи);
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ОформляемоеПоле);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ЭлементУсловногоОформления.Отбор,
		ПутьКДанным,
		СписокСтатусов,
		ВидСравненияКомпоновкиДанных.ВСписке,
		ПредставлениеЭлемента,
		Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает данные акта подтверждения ТТН.
//
Функция ИнициализироватьДанныеАктаПодтвержденияТТН(ДокументСсылка)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТТНВходящаяЕГАИС.Номер КАК Номер,
	|	ЛОЖЬ КАК Отказ,
	|	ТТНВходящаяЕГАИС.ИдентификаторЕГАИС КАК ИдентификаторЕГАИС,
	|	ТТНВходящаяЕГАИС.Комментарий КАК Комментарий
	|ИЗ
	|	Документ.ТТНВходящаяЕГАИС КАК ТТНВходящаяЕГАИС
	|ГДЕ
	|	ТТНВходящаяЕГАИС.Ссылка = &Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ДанныеАкта = ИнтеграцияЕГАИСКлиентСервер.СтруктураДанныхАктаПодтвержденияТТН();
	ЗаполнитьЗначенияСвойств(ДанныеАкта, Выборка);
	ДанныеАкта.Идентификатор = Строка(ДокументСсылка.УникальныйИдентификатор());
	
	Возврат ДанныеАкта;
	
КонецФункции

// Возвращает данные акта отказа от ТТН.
//
Функция ИнициализироватьДанныеАктаОтказаОтТТН(ДокументСсылка)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТТНВходящаяЕГАИС.Номер КАК Номер,
	|	ИСТИНА КАК Отказ,
	|	ТТНВходящаяЕГАИС.ИдентификаторЕГАИС КАК ИдентификаторЕГАИС,
	|	ТТНВходящаяЕГАИС.Комментарий КАК Комментарий
	|ИЗ
	|	Документ.ТТНВходящаяЕГАИС КАК ТТНВходящаяЕГАИС
	|ГДЕ
	|	ТТНВходящаяЕГАИС.Ссылка = &Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ДанныеАкта = ИнтеграцияЕГАИСКлиентСервер.СтруктураДанныхАктаПодтвержденияТТН();
	ЗаполнитьЗначенияСвойств(ДанныеАкта, Выборка);
	ДанныеАкта.Идентификатор = Строка(ДокументСсылка.УникальныйИдентификатор());
	
	Возврат ДанныеАкта;
	
КонецФункции

// Возвращает данные акта расхождений ТТН.
//
Функция ИнициализироватьДанныеАктаРасхожденийТТН(ДокументСсылка)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТТНВходящаяЕГАИС.Номер КАК Номер,
	|	ЛОЖЬ КАК Отказ,
	|	ТТНВходящаяЕГАИС.ИдентификаторЕГАИС КАК ИдентификаторЕГАИС,
	|	ТТНВходящаяЕГАИС.Комментарий КАК Комментарий
	|ИЗ
	|	Документ.ТТНВходящаяЕГАИС КАК ТТНВходящаяЕГАИС
	|ГДЕ
	|	ТТНВходящаяЕГАИС.Ссылка = &Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ДанныеАкта = ИнтеграцияЕГАИСКлиентСервер.СтруктураДанныхАктаПодтвержденияТТН();
	ЗаполнитьЗначенияСвойств(ДанныеАкта, Выборка);
	ДанныеАкта.Идентификатор = Строка(ДокументСсылка.УникальныйИдентификатор());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТТНВходящаяЕГАИСТовары.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	ТТНВходящаяЕГАИСТовары.СправкаБ.РегистрационныйНомер КАК НомерСправкиБ,
	|	ТТНВходящаяЕГАИСТовары.КоличествоФакт КАК КоличествоФакт
	|ИЗ
	|	Документ.ТТНВходящаяЕГАИС.Товары КАК ТТНВходящаяЕГАИСТовары
	|ГДЕ
	|	ТТНВходящаяЕГАИСТовары.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	ИдентификаторСтроки";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаАкта = Новый Структура;
		СтрокаАкта.Вставить("ИдентификаторСтроки", Выборка.ИдентификаторСтроки);
		СтрокаАкта.Вставить("НомерСправкиБ", Выборка.НомерСправкиБ);
		СтрокаАкта.Вставить("КоличествоФакт", Выборка.КоличествоФакт);
		
		ДанныеАкта.ТаблицаТоваров.Добавить(СтрокаАкта);
	КонецЦикла;
	
	Возврат ДанныеАкта;
	
КонецФункции

// Возвращает данные запроса на отмену проведения ТТН.
//
Функция ИнициализироватьДанныеЗапросаНаОтменуПроведенияТТН(ДокументСсылка)
	
	ДанныеЗапроса = ИнтеграцияЕГАИСКлиентСервер.СтруктураДанныхЗапросаНаОтменуПроведения();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("Дата"  , ТекущаяДатаСеанса());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТТНВходящаяЕГАИС.Грузополучатель.Код КАК ИдентификаторФСРАР,
	|	ТТНВходящаяЕГАИС.Номер КАК Номер,
	|	&Дата КАК Дата,
	|	ТТНВходящаяЕГАИС.ИдентификаторЕГАИС КАК ИдентификаторЕГАИС
	|ИЗ
	|	Документ.ТТНВходящаяЕГАИС КАК ТТНВходящаяЕГАИС
	|ГДЕ
	|	ТТНВходящаяЕГАИС.Ссылка = &Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ЗаполнитьЗначенияСвойств(ДанныеЗапроса, Выборка);
	
	Возврат ДанныеЗапроса;
	
КонецФункции

#КонецОбласти

#КонецЕсли