﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Функция формирует наименование банковского счета.
//
&НаКлиенте
Функция СформироватьАвтоНаименование()
	
	Элементы.Наименование.СписокВыбора.Очистить();
	
	СтрокаНаименования = НСтр("ru='Эквайринговый терминал '") + " (" + Строка(Объект.Касса) + ")";
	СтрокаНаименования = Лев(СтрокаНаименования, 100);
	
	Элементы.Наименование.СписокВыбора.Добавить(СтрокаНаименования);
	
	Возврат СтрокаНаименования;

КонецФункции // СформироватьАвтоНаименование()

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПриСозданииНаСервере" формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) И НЕ ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		ЗначениеНастройки = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
			Пользователи.ТекущийПользователь(),
			"ОсновнаяОрганизация"
		);
		Если ЗначениеЗаполнено(ЗначениеНастройки) Тогда
			Объект.Организация = ЗначениеНастройки;
		Иначе
			Объект.Организация = Справочники.Организации.ОсновнаяОрганизация;
		КонецЕсли;
		Если НЕ Константы.ФункциональнаяОпцияИспользоватьПодключаемоеОборудование.Получить() Тогда
			Объект.ИспользоватьБезПодключенияОборудования = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если Объект.ИспользоватьБезПодключенияОборудования
	И НЕ Константы.ФункциональнаяОпцияИспользоватьПодключаемоеОборудование.Получить() Тогда
		Элементы.ИспользоватьБезПодключенияОборудования.Доступность = Ложь;
	КонецЕсли;
	
	Элементы.ПодключаемоеОборудование.Доступность = НЕ Объект.ИспользоватьБезПодключенияОборудования;
	
	Валюта = Объект.Договор.ВалютаРасчетов;
	УчетВалютныхОпераций = ПолучитьФункциональнуюОпцию("УчетВалютныхОпераций");
	Элементы.Валюта.Видимость = УчетВалютныхОпераций;
	Элементы.Договор.АвтоМаксимальнаяШирина = НЕ УчетВалютныхОпераций;
	
	// Установка видимости договора.
	УстановитьВидимостьДоговора();
	
	// Установка видимости вида кассы.
	НастроитьВидКассы();
	
	// Подсистема запрета редактирования ключевых реквизитов объектов.
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
КонецПроцедуры // ПриСозданииНаСервере()

// Процедура - обработчик события "ПередЗаписью" формы.
//
&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)

	Если ПустаяСтрока(Объект.Наименование) Тогда
		Объект.Наименование = СформироватьАвтоНаименование();
	КонецЕсли;
	
	Если Объект.СчетЗатрат.Пустая() Тогда
		Объект.СчетЗатрат = ПредопределенноеЗначение("ПланСчетов.Управленческий.ПрочиеРасходы");
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события "ПослеЗаписиНаСервере" формы.
//
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
КонецПроцедуры // ПослеЗаписиНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СформироватьАвтоНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьБезПодключенияОборудованияПриИзменении(Элемент)
	
	Элементы.ПодключаемоеОборудование.Доступность = НЕ Объект.ИспользоватьБезПодключенияОборудования;
	
КонецПроцедуры

&НаКлиенте
Процедура КассаПриИзменении(Элемент)
	
	СформироватьАвтоНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменилсяСчетУчетаЭквайринговыеТерминалы" Тогда
		Объект.СчетУчета = Параметр.СчетУчета;
		Объект.СчетЗатрат = Параметр.СчетЗатрат;
		Модифицированность = Истина;
	ИначеЕсли ИмяСобытия = "Запись_Контрагент" 
		И ЗначениеЗаполнено(Параметр)
		И Объект.Эквайрер = Параметр Тогда
		УстановитьВидимостьДоговора();
	КонецЕсли;
	
КонецПроцедуры

// Процедура устанавливает видимость договора в зависимости от установленного параметра эквайрера (контрагента).
//
&НаСервере
Процедура УстановитьВидимостьДоговора()
	
	Если ЗначениеЗаполнено(Объект.Эквайрер) Тогда
		
		ПараметрыРасчетовСКонтрагентом = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Эквайрер, "ВестиРасчетыПоДоговорам");
		Элементы.Договор.Видимость = ПараметрыРасчетовСКонтрагентом.ВестиРасчетыПоДоговорам;
		
	Иначе
		
		Элементы.Договор.Видимость = Ложь;
		
	КонецЕсли;
	
	Элементы.Валюта.Видимость = Элементы.Договор.Видимость;
	
КонецПроцедуры // УстановитьВидимостьДоговора()

// Получает договор по умолчанить в зависимости от способа ведения расчетов.
//
&НаСервереБезКонтекста
Функция ПолучитьДоговорПоУмолчанию(Документ, Контрагент, Организация)
	
	Если Не Контрагент.ВестиРасчетыПоДоговорам Тогда
		Возврат Контрагент.ДоговорПоУмолчанию;
	КонецЕсли;
	
	МенеджерСправочника = Справочники.ДоговорыКонтрагентов;
	
	СписокВидовДоговоров = МенеджерСправочника.ПолучитьСписокВидовДоговораДляДокумента(Документ);
	ДоговорПоУмолчанию = МенеджерСправочника.ПолучитьДоговорПоУмолчаниюПоОрганизацииВидуДоговора(Контрагент, Организация, СписокВидовДоговоров);
	
	Возврат ДоговорПоУмолчанию;
	
КонецФункции

&НаСервере
Процедура НастроитьВидКассы()
	
	УчетРозничныхПродаж = ПолучитьФункциональнуюОпцию("УчетРозничныхПродаж");
	Если УчетРозничныхПродаж Тогда
		Элементы.ВидКассы.Видимость = Истина;
		Элементы.Касса.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
		
		Если ТипЗнч(Объект.Касса) = Тип("СправочникСсылка.КассыККМ") Тогда
			ВидКассы = "КассаККМ";
			Элементы.Касса.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.КассыККМ");
		Иначе
			ВидКассы = "Касса";
			Элементы.Касса.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Кассы");
		КонецЕсли;
	// Если нет розничных продаж и касса не выбрана.
	ИначеЕсли Объект.Касса.Пустая() Тогда
		Элементы.ВидКассы.Видимость = Ложь;
		Элементы.Касса.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Авто;
		
		ВидКассы = "Касса";
		Элементы.Касса.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Кассы");
	// Если нет розничных продаж и выбрана касса ККМ.
	ИначеЕсли ТипЗнч(Объект.Касса) = Тип("СправочникСсылка.КассыККМ") Тогда
		Элементы.ВидКассы.Видимость = Истина;
		Элементы.Касса.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
		
		ВидКассы = "КассаККМ";
		Элементы.Касса.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.КассыККМ");
	// Если нет розничных продаж и выбрана касса ОРГАНИЗАЦИИ.
	Иначе
		Элементы.ВидКассы.Видимость = Ложь;
		Элементы.Касса.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Авто;
		
		ВидКассы = "Касса";
		Элементы.Касса.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Кассы");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭквайрерПриИзменении(Элемент)
	
	ЭквайрерПередИзменением = Эквайрер;
	Эквайрер = Объект.Эквайрер;
	
	Если ЭквайрерПередИзменением <> Объект.Эквайрер Тогда
		
		ВидимостьДоговораПередИзменением = Элементы.Договор.Видимость;
		
		Объект.Договор = ПолучитьДоговорПоУмолчанию(Объект.Ссылка, Эквайрер, Объект.Организация);
		ДоговорПередИзменением = Договор;
		Договор = Объект.Договор;
		ДоговорПриИзмененииНаСервере();
		
	Иначе
		
		Объект.Договор = Договор; // Восстанавливаем автоматически очищеный договор.
		
	КонецЕсли;
	
	УстановитьВидимостьДоговора();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидКассыПриИзменении(Элемент)
	
	Если ПустаяСтрока(ВидКассы) Тогда
		 ВидКассы = "Касса";
	КонецЕсли;
	
	Если ВидКассы = "КассаККМ" Тогда
		Элементы.Касса.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.КассыККМ");
		Если ТипЗнч(Объект.Касса) <> Тип("СправочникСсылка.КассыККМ") Тогда
			Объект.Касса = Неопределено;
		КонецЕсли;
	Иначе
		Элементы.Касса.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Кассы");
		Если ТипЗнч(Объект.Касса) <> Тип("СправочникСсылка.Кассы") Тогда
			Объект.Касса = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ВалютаДоговора = ТекущийОбъект.Договор.ВалютаРасчетов;
	ВалютаСчета = ТекущийОбъект.БанковскийСчетЭквайринг.ВалютаДенежныхСредств;
	Если ВалютаДоговора <> ВалютаСчета Тогда
		Отказ = Истина;
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Элемент не записан. Валюта договора эквайринга ("+ВалютаДоговора+") должна совпадать с валютой банковского счета ("+ВалютаСчета+")";
		Сообщение.Сообщить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорПриИзменении(Элемент)
	
	ДоговорПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ДоговорПриИзмененииНаСервере()
	
	Если Валюта <> Объект.Договор.ВалютаРасчетов Тогда
		Валюта = Объект.Договор.ВалютаРасчетов;
		Объект.БанковскийСчетЭквайринг = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
		
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
		
КонецПроцедуры
