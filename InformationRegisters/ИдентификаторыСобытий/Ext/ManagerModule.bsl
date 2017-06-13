﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Записывает идентификатор события.
//
// Параметры:
//  УчетнаяЗапись	 - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты
//  Событие			 - ДокументСсылка.Событие - событие, для которого записываются идентификаторы
//  Идентификатор	 - Строка - уникальный в пределах почтового ящика идентификатор письма
//                     на почтовом сервере (из свойства ИнтернетПочтовоеСообщение.Идентификатор)
//
Процедура ЗаписатьИдентификатор(Знач УчетнаяЗапись, Знач Событие, Знач Идентификатор) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Ключ = ОбменСGoogle.КлючИзИдентификатора(
	Идентификатор,
	"РС.ИдентификаторыСобытий.ЗаписатьИдентификатор()");
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.УчетнаяЗапись = УчетнаяЗапись;
	МенеджерЗаписи.Событие = Событие;
	МенеджерЗаписи.Ключ = Ключ;
	МенеджерЗаписи.Прочитать();
	
	Если МенеджерЗаписи.Выбран() Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерЗаписи.УчетнаяЗапись = УчетнаяЗапись;
	МенеджерЗаписи.Событие = Событие;
	МенеджерЗаписи.Ключ = Ключ;
	МенеджерЗаписи.Идентификатор = Идентификатор;
	
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

// Возвращает уникальный в пределах почтового ящика идентификатор письма на почтовом сервере.
//
// Параметры:
//  УчетнаяЗапись	 - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты,
//  Событие			 - ДокументСсылка.Событие - событие, для которого должен быть получен идентификатор.
// 
// Возвращаемое значение:
//  Строка - уникальный в пределах почтового ящика идентификатор письма на почтовом сервере.
//
Функция ИдентификаторСобытия(Знач УчетнаяЗапись, Знач Событие) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИдентификаторыСобытий.Идентификатор
	|ИЗ
	|	РегистрСведений.ИдентификаторыСобытий КАК ИдентификаторыСобытий
	|ГДЕ
	|	ИдентификаторыСобытий.УчетнаяЗапись = &УчетнаяЗапись
	|	И ИдентификаторыСобытий.Событие = &Событие");
	Запрос.УстановитьПараметр("Событие", Событие);
	Запрос.УстановитьПараметр("УчетнаяЗапись", УчетнаяЗапись);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат "";
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Идентификатор;
	
КонецФункции

// Возвращает соответствие Событий указанным идентификаторам.
//
// Параметры:
//  УчетнаяЗапись	 - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты,
//  Идентификаторы	 - Массив - массив уникальных в пределах почтового ящика идентификаторов.
// 
// Возвращаемое значение:
//  Соответствие - Ключ - Идентификатор, Значение - Событие.
//
Функция СобытияПоИдентификаторам(Знач УчетнаяЗапись, Знач Идентификаторы) Экспорт
	
	Результат = Новый Соответствие;
	
	Если Не ЗначениеЗаполнено(Идентификаторы) Тогда
		Возврат Результат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТаблицаИдентификаторов = Новый ТаблицаЗначений;
	ТаблицаИдентификаторов.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
	ТаблицаИдентификаторов.Колонки.Добавить("Ключ", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(64)));
	
	Для Каждого ТекИдентификатор Из Идентификаторы Цикл
		ТекСтрокаТаблицаИдентификаторов = ТаблицаИдентификаторов.Добавить();
		ТекСтрокаТаблицаИдентификаторов.Идентификатор = ТекИдентификатор;
		ТекСтрокаТаблицаИдентификаторов.Ключ = ОбменСGoogle.КлючИзИдентификатора(
		ТекСтрокаТаблицаИдентификаторов.Идентификатор,
		"РС.ИдентификаторыСобытий.СобытияПоИдентификаторам()");
	КонецЦикла;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаИдентификаторов.Идентификатор КАК Идентификатор,
	|	ТаблицаИдентификаторов.Ключ КАК Ключ
	|ПОМЕСТИТЬ ИдентификаторыПисемНаСервере
	|ИЗ
	|	&ТаблицаИдентификаторов КАК ТаблицаИдентификаторов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаИдентификаторов.Идентификатор,
	|	ТаблицаИдентификаторов.Ключ,
	|	ИдентификаторыСобытий.Событие
	|ИЗ
	|	РегистрСведений.ИдентификаторыСобытий КАК ИдентификаторыСобытий
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ИдентификаторыПисемНаСервере КАК ТаблицаИдентификаторов
	|		ПО ИдентификаторыСобытий.Ключ = ТаблицаИдентификаторов.Ключ
	|ГДЕ
	|	ИдентификаторыСобытий.УчетнаяЗапись = &УчетнаяЗапись");
	
	Запрос.УстановитьПараметр("УчетнаяЗапись", УчетнаяЗапись);
	Запрос.УстановитьПараметр("ТаблицаИдентификаторов", ТаблицаИдентификаторов);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Результат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		Результат[Выборка.Идентификатор] = Выборка.Событие;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ИдентификаторыПослеДатыОтправления(Знач УчетнаяЗапись, Знач ПослеДатыОтправления) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ИдентификаторыСобытий.Идентификатор
	|ИЗ
	|	РегистрСведений.ИдентификаторыСобытий КАК ИдентификаторыСобытий
	|ГДЕ
	|	ИдентификаторыСобытий.УчетнаяЗапись = &УчетнаяЗапись
	|	И ИдентификаторыСобытий.Событие.НачалоСобытия >= &ПослеДатыОтправления");
	Запрос.УстановитьПараметр("УчетнаяЗапись", УчетнаяЗапись);
	Запрос.УстановитьПараметр("ПослеДатыОтправления", ПослеДатыОтправления);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Идентификатор");
	
КонецФункции

Функция ИдентификаторыПоКонтакту(Знач УчетнаяЗапись, Знач Контакт) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ИдентификаторыСобытий.Идентификатор
	|ИЗ
	|	РегистрСведений.ИдентификаторыСобытий КАК ИдентификаторыСобытий
	|ГДЕ
	|	ИдентификаторыСобытий.УчетнаяЗапись = &УчетнаяЗапись
	|	И ИдентификаторыСобытий.Событие.Участники.Контакт = &Контакт");
	Запрос.УстановитьПараметр("УчетнаяЗапись", УчетнаяЗапись);
	Запрос.УстановитьПараметр("Контакт", Контакт);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Идентификатор");
	
КонецФункции

#КонецОбласти

#КонецЕсли