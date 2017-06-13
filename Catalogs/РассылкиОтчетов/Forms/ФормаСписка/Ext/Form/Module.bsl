﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(
		Список,
		"ПоследнийЗапуск",
		Элементы.ПоследнийЗапуск.Имя);
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(
		Список,
		"УспешныйЗапуск",
		Элементы.УспешныйЗапуск.Имя);
	
	ТекстОшибкиПриОткрытии = РассылкаОтчетовПовтИсп.ТекстОшибкиПроверкиПраваДобавления();
	Если ЗначениеЗаполнено(ТекстОшибкиПриОткрытии) Тогда
		Возврат;
	КонецЕсли;
	
	// Установка отборов динамического списка.
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "ВыполнятьПоРасписанию", Ложь,
		ВидСравненияКомпоновкиДанных.Равно, , Ложь,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "ПериодичностьРасписания", ,
		ВидСравненияКомпоновкиДанных.Равно, , Ложь,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Подготовлена", Ложь,
		ВидСравненияКомпоновкиДанных.Равно, , Ложь,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Автор", ,
		ВидСравненияКомпоновкиДанных.Равно, , Ложь,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный);
	
	ЗаполнитьПараметрСписка("РежимВыбора");
	ЗаполнитьПараметрСписка("ВыборГруппИЭлементов");
	ЗаполнитьПараметрСписка("МножественныйВыбор");
	ЗаполнитьПараметрСписка("ТекущаяСтрока");
	
	Если Параметры.РежимВыбора Тогда
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ФОРМАВЫБРАТЬ",
			"КнопкаПоУмолчанию",
			Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ФОРМАВЫБРАТЬ",
			"Видимость",
			Ложь);
	КонецЕсли;
	
	Если НЕ Пользователи.РолиДоступны("ДобавлениеИзменениеРассылокОтчетов") Тогда
		// Режим показа только личных рассылок - скрываются группы и лишние колонки.
		Элементы.Список.Отображение = ОтображениеТаблицы.Список;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ЭтоГруппа", Ложь, , , Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("ПустаяДата", '00010101');
	Список.Параметры.УстановитьЗначениеПараметра("ПредставлениеСостоянияНовая", НСтр("ru = 'Новая'"));
	Список.Параметры.УстановитьЗначениеПараметра("ПредставлениеСостоянияНеВыполнена", НСтр("ru = 'Не выполнена'"));
	Список.Параметры.УстановитьЗначениеПараметра("ПредставлениеСостоянияВыполненаСОшибками", НСтр("ru = 'Выполнена с ошибками'"));
	Список.Параметры.УстановитьЗначениеПараметра("ПредставлениеСостоянияВыполнена", НСтр("ru = 'Выполнена'"));
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов") Тогда
		Элементы.ИзменитьВыделенные.Видимость = Ложь;
		Элементы.ИзменитьВыделенныеСписок.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ПравоДоступа("ЖурналРегистрации", Метаданные) Тогда
		Элементы.СобытияРассылки.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ЗначениеЗаполнено(ТекстОшибкиПриОткрытии) Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(, ТекстОшибкиПриОткрытии);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	МодульГрупповоеИзменениеОбъектовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ГрупповоеИзменениеОбъектовКлиент");
	МодульГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьПараметрСписка(Ключ)
	Если Параметры.Свойство(Ключ) И ЗначениеЗаполнено(Параметры[Ключ]) Тогда
		Элементы.Список[Ключ] = Параметры[Ключ];
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
