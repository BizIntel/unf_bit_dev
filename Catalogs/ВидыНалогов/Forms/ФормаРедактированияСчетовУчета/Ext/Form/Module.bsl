﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Функция проверяет возможность изменения счета учета.
//
&НаСервере
Функция ОтказИзменитьСчетУчета(Ссылка)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	РасчетыПоНалогам.Период,
	|	РасчетыПоНалогам.Регистратор,
	|	РасчетыПоНалогам.НомерСтроки,
	|	РасчетыПоНалогам.Активность,
	|	РасчетыПоНалогам.ВидДвижения,
	|	РасчетыПоНалогам.Организация,
	|	РасчетыПоНалогам.ВидНалога,
	|	РасчетыПоНалогам.Сумма,
	|	РасчетыПоНалогам.СодержаниеПроводки
	|ИЗ
	|	РегистрНакопления.РасчетыПоНалогам КАК РасчетыПоНалогам
	|ГДЕ
	|	РасчетыПоНалогам.ВидНалога = &ВидНалога");
	
	Запрос.УстановитьПараметр("ВидНалога", ?(ЗначениеЗаполнено(Ссылка), Ссылка, Неопределено));
	
	Результат = Запрос.Выполнить();
	
	Возврат НЕ Результат.Пустой();
	
КонецФункции // ОтказИзменитьСчетУчета()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события ПриСозданииНаСервере формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СчетУчета = Параметры.СчетУчета;
	СчетУчетаКВозмещению = Параметры.СчетУчетаКВозмещению;
	Ссылка = Параметры.Ссылка;
	
	Если ОтказИзменитьСчетУчета(Ссылка) Тогда
		Элементы.ГруппаСчетовУчета.Подсказка = НСтр("ru = 'В базе есть движения по этому виду налога! Изменение счета учета запрещено!'");
		Элементы.ГруппаСчетовУчета.Доступность = Ложь;
		Элементы.ПоУмолчанию.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// Процедура - обработчик нажатия команды ПоУмолчанию.
//
&НаКлиенте
Процедура ПоУмолчанию(Команда)
	
	СчетУчета = ПредопределенноеЗначение("ПланСчетов.Управленческий.Налоги");
	СчетУчетаКВозмещению = ПредопределенноеЗначение("ПланСчетов.Управленческий.НалогиКВозмещению");
	ОповеститьОбИзмененииСчетов();
	
КонецПроцедуры // ПоУмолчанию()

&НаКлиенте
Процедура ОповеститьОбИзмененииСчетов()
	
	СтруктураПараметры = Новый Структура(
		"СчетУчета, СчетУчетаКВозмещению",
		СчетУчета, СчетУчетаКВозмещению
	);
	
	Оповестить("ИзменилисьСчетаВидыНалогов", СтруктураПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура СчетУчетаПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(СчетУчета) Тогда
		СчетУчета = ПредопределенноеЗначение("ПланСчетов.Управленческий.Налоги");
	КонецЕсли;
	ОповеститьОбИзмененииСчетов();
	
КонецПроцедуры

&НаКлиенте
Процедура СчетУчетаКВозмещениюПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(СчетУчетаКВозмещению) Тогда
		СчетУчета = ПредопределенноеЗначение("ПланСчетов.Управленческий.НалогиКВозмещению");
	КонецЕсли;
	ОповеститьОбИзмененииСчетов();
	
КонецПроцедуры
