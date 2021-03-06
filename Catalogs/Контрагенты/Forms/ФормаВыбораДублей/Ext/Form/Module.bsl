﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокДублей.Параметры.УстановитьЗначениеПараметра("ИНН", СокрЛП(Параметры.ИНН));
	СписокДублей.Параметры.УстановитьЗначениеПараметра("КПП", СокрЛП(Параметры.КПП));
	
	Если НЕ Параметры.ЭтоЮрЛицо Тогда
		Элементы.СписокКПП.Видимость = Ложь;
	КонецЕсли;
	
	Заголовок = ?(ЗначениеЗаполнено(Параметры.КПП),
					НСтр("ru = 'Список дублей по ИНН и КПП'"),
					НСтр("ru = 'Список дублей по ИНН'"));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокДублейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыПередачи = Новый Структура("Ключ", Элемент.ТекущиеДанные.Ссылка);
	ПараметрыПередачи.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
	
	ОткрытьФорму("Справочник.Контрагенты.ФормаОбъекта",
				ПараметрыПередачи, 
				Элемент,
				,
				,
				,
				Новый ОписаниеОповещения("ОбработатьРедактированиеЭлемента", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДублейПриАктивизацииСтроки(Элемент)
	
	ДанныеТекущейСтроки = Элементы.СписокДублей.ТекущиеДанные;
	
	Если НЕ ДанныеТекущейСтроки = Неопределено Тогда
		
		ПодключитьОбработчикОжидания("ОбработатьАктивизациюСтрокиСписка", 0.2, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьДокументыПоКонтрагенту(Команда)
	
	ТекущиеДанныеСписка = Элементы.СписокДублей.ТекущиеДанные;
	Если ТекущиеДанныеСписка = Неопределено Тогда
		ТекстПредупреждения = НСтр("ru = 'Команда не может быть выполнена для указанного объекта!'");
		ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Контрагент", ТекущиеДанныеСписка.Ссылка);
	
	ОткрытьФорму("ЖурналДокументов.ДокументыПоКонтрагенту.Форма.ФормаСписка",
		ПараметрыФормы,
		ЭтотОбъект,
		,
		,
		,
		,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца
	);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьРедактированиеЭлемента(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Элементы.СписокДублей.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьАктивизациюСтрокиСписка()
	
	ТекущиеДанныеСписка = Элементы.СписокДублей.ТекущиеДанные;
	Если ТекущиеДанныеСписка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ОткрытьДокументыПоКонтрагенту.Заголовок = СтрШаблон(НСтр("ru='Документы по контрагенту (%1)'"),
		ПолучитьКоличествоДокументовКонтрагента(ТекущиеДанныеСписка.Ссылка)
	);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьКоличествоДокументовКонтрагента(Контрагент)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДокументыПоКонтрагенту.Ссылка) КАК КоличествоДокументов
		|ИЗ
		|	КритерийОтбора.ДокументыПоКонтрагенту(&Контрагент) КАК ДокументыПоКонтрагенту";
	
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат 0;
	Иначе
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.КоличествоДокументов;
	КонецЕсли;
	
КонецФункции

#КонецОбласти
