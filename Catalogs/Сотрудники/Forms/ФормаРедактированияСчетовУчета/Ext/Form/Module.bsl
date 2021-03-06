﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Функция проверяет возможность изменения счета.
//
&НаСервере
Функция ОтказИзменитьСчетРасчетовСПерсоналом(Ссылка)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	РасчетыСПерсоналом.Период,
	|	РасчетыСПерсоналом.Регистратор,
	|	РасчетыСПерсоналом.НомерСтроки,
	|	РасчетыСПерсоналом.Активность,
	|	РасчетыСПерсоналом.ВидДвижения,
	|	РасчетыСПерсоналом.Организация,
	|	РасчетыСПерсоналом.СтруктурнаяЕдиница,
	|	РасчетыСПерсоналом.Сотрудник,
	|	РасчетыСПерсоналом.Валюта,
	|	РасчетыСПерсоналом.ПериодРегистрации,
	|	РасчетыСПерсоналом.Сумма,
	|	РасчетыСПерсоналом.СуммаВал,
	|	РасчетыСПерсоналом.СодержаниеПроводки
	|ИЗ
	|	РегистрНакопления.РасчетыСПерсоналом КАК РасчетыСПерсоналом
	|ГДЕ
	|	РасчетыСПерсоналом.Сотрудник = &Сотрудник");
	
	Запрос.УстановитьПараметр("Сотрудник", ?(ЗначениеЗаполнено(Ссылка), Ссылка, Неопределено));
	
	Результат = Запрос.Выполнить();
	
	Возврат НЕ Результат.Пустой();
	
КонецФункции // ОтказИзменитьСчетРасчетовСПерсоналом()

// Функция проверяет возможность изменения счета.
//
&НаСервере
Функция ОтказИзменитьСчетРасчетовСПодотчетниками(Ссылка)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	РасчетыСПодотчетниками.Период,
	|	РасчетыСПодотчетниками.Регистратор,
	|	РасчетыСПодотчетниками.НомерСтроки,
	|	РасчетыСПодотчетниками.Активность,
	|	РасчетыСПодотчетниками.ВидДвижения,
	|	РасчетыСПодотчетниками.Организация,
	|	РасчетыСПодотчетниками.Сотрудник,
	|	РасчетыСПодотчетниками.Валюта,
	|	РасчетыСПодотчетниками.Документ,
	|	РасчетыСПодотчетниками.Сумма,
	|	РасчетыСПодотчетниками.СуммаВал,
	|	РасчетыСПодотчетниками.СодержаниеПроводки
	|ИЗ
	|	РегистрНакопления.РасчетыСПодотчетниками КАК РасчетыСПодотчетниками
	|ГДЕ
	|	РасчетыСПодотчетниками.Сотрудник = &Сотрудник");
	
	Запрос.УстановитьПараметр("Сотрудник", ?(ЗначениеЗаполнено(Ссылка), Ссылка, Неопределено));
	
	Результат = Запрос.Выполнить();
	
	Возврат НЕ Результат.Пустой();
	
КонецФункции // ОтказИзменитьСчетРасчетовСПодотчетниками()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события ПриСозданииНаСервере формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СчетРасчетовСПерсоналом = Параметры.СчетРасчетовСПерсоналом;
	СчетРасчетовСПодотчетниками = Параметры.СчетРасчетовСПодотчетниками;
	СчетРасчетовПоПерерасходу = Параметры.СчетРасчетовПоПерерасходу;
	Ссылка = Параметры.Ссылка;
	
	Если ОтказИзменитьСчетРасчетовСПерсоналом(Ссылка) Тогда
		Элементы.СПерсоналом.Подсказка = НСтр("ru = 'В базе есть движения по этому сотруднику! Изменение счетов учета по расчетам с персоналом запрещено!'");
		Элементы.СПерсоналом.Доступность = Ложь;
	КонецЕсли;

	Если ОтказИзменитьСчетРасчетовСПодотчетниками(Ссылка) Тогда
		Элементы.СПодотчетником.Подсказка = НСтр("ru = 'В базе есть движения по этому подотчетнику! Изменение счетов учета по расчетам с подотчетниками запрещено!'");
		Элементы.СПодотчетником.Доступность = Ложь;
	КонецЕсли;
	
	Если НЕ Элементы.СПерсоналом.Доступность
		И НЕ Элементы.СПодотчетником.Доступность Тогда
		Элементы.ПоУмолчанию.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// Процедура - обработчик нажатия команды ПоУмолчанию.
//
&НаКлиенте
Процедура ПоУмолчанию(Команда)
	
	СчетРасчетовСПерсоналом = ПредопределенноеЗначение("ПланСчетов.Управленческий.РасчетыСПерсоналомПоОплатеТруда");
	СчетРасчетовСПодотчетниками = ПредопределенноеЗначение("ПланСчетов.Управленческий.РасчетыСПодотчетниками");
	СчетРасчетовПоПерерасходу = ПредопределенноеЗначение("ПланСчетов.Управленческий.ПерерасходПодотчетников");
	
КонецПроцедуры // ПоУмолчанию()

&НаКлиенте
Процедура СчетРасчетовСПерсоналомПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(СчетРасчетовСПерсоналом) Тогда
		СчетРасчетовСПерсоналом = ПредопределенноеЗначение("ПланСчетов.Управленческий.РасчетыСПерсоналомПоОплатеТруда");
	КонецЕсли;
	ОповеститьОбИзмененииСчетовРасчетов();
	
КонецПроцедуры

&НаКлиенте
Процедура СчетРасчетовСПодотчетникамиПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(СчетРасчетовСПодотчетниками) Тогда
		СчетРасчетовСПодотчетниками = ПредопределенноеЗначение("ПланСчетов.Управленческий.РасчетыСПодотчетниками");
	КонецЕсли;
	ОповеститьОбИзмененииСчетовРасчетов();
	
КонецПроцедуры

&НаКлиенте
Процедура СчетРасчетовПоПерерасходуПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(СчетРасчетовПоПерерасходу) Тогда
		СчетРасчетовПоПерерасходу = ПредопределенноеЗначение("ПланСчетов.Управленческий.ПерерасходПодотчетников");
	КонецЕсли;
	ОповеститьОбИзмененииСчетовРасчетов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОбИзмененииСчетовРасчетов()
	
	СтруктураПараметры = Новый Структура(
		"СчетРасчетовСПерсоналом, СчетРасчетовСПодотчетниками, СчетРасчетовПоПерерасходу",
		СчетРасчетовСПерсоналом, СчетРасчетовСПодотчетниками, СчетРасчетовПоПерерасходу
	);
	
	Оповестить("ИзменилисьСчетаСотрудники", СтруктураПараметры);
	
КонецПроцедуры
