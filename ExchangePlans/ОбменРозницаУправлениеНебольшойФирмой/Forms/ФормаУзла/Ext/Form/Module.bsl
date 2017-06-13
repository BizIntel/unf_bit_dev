﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИспользоватьНесколькоОрганизаций = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
	ОбновитьНаименованиеКомандФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ОбновитьИнтерфейс();
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Оповестить("Запись_УзелПланаОбмена");
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ФормаНастройкиПередЗакрытием(Отказ, ЭтотОбъект, ЗавершениеРаботы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ОбновитьДанныеОбъекта(ВыбранноеЗначение);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если Не Объект.ИспользоватьОтборПоОрганизациям И Объект.Организации.Количество() <> 0 Тогда
		Объект.Организации.Очистить();
	ИначеЕсли Объект.ИспользоватьОтборПоОрганизациям И Объект.Организации.Количество() = 0 Тогда
		Объект.ИспользоватьОтборПоОрганизациям = Ложь;
	КонецЕсли;
	
	Если Не Объект.ИспользоватьОтборПоСкладам И Объект.Склады.Количество() <> 0 Тогда
		Объект.Склады.Очистить();
	ИначеЕсли Объект.ИспользоватьОтборПоСкладам И Объект.Склады.Количество() = 0 Тогда
		Объект.ИспользоватьОтборПоСкладам = Ложь;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьСписокВыбранныхОрганизацийНажатие(Элемент)
	КоллекцияФильтров = Неопределено;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ИмяЭлементаФормыДляЗаполнения",          "Организации");
	ПараметрыФормы.Вставить("ИмяРеквизитаЭлементаФормыДляЗаполнения", "Организация");
	ПараметрыФормы.Вставить("ИмяТаблицыВыбора",                       "Справочник.Организации");
	ПараметрыФормы.Вставить("ЗаголовокФормыВыбора",                   НСтр("ru = 'Выберите организации для отбора:'"));
	ПараметрыФормы.Вставить("МассивВыбранныхЗначений",                СформироватьМассивВыбранныхЗначений(ПараметрыФормы));
	ПараметрыФормы.Вставить("ПараметрыВнешнегоСоединения",            Неопределено);
	ПараметрыФормы.Вставить("КоллекцияФильтров",                      КоллекцияФильтров);

	ОткрытьФорму("ПланОбмена.ОбменРозницаУправлениеНебольшойФирмой.Форма.ФормаВыбораДополнительныхУсловий",
		ПараметрыФормы,
		ЭтаФорма);
	КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокВыбранныхСкладовНажатие(Элемент)
	
	КоллекцияФильтров = Новый Массив;
	Фильтр = Новый Структура;
	Фильтр.Вставить("Условие"," = ");
	Фильтр.Вставить("РеквизитОтбора","ТипСтруктурнойЕдиницы");
	Фильтр.Вставить("ИмяПараметра","ТипСтруктурнойЕдиницы");
	Фильтр.Вставить("ЗначениеПараметра", ПредопределенноеЗначение("Перечисление.ТипыСтруктурныхЕдиниц.Розница"));
	КоллекцияФильтров.Добавить(Фильтр);
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ИмяЭлементаФормыДляЗаполнения",          "Склады");
	ПараметрыФормы.Вставить("ИмяРеквизитаЭлементаФормыДляЗаполнения", "Склад");
	ПараметрыФормы.Вставить("ИмяТаблицыВыбора",                       "Справочник.СтруктурныеЕдиницы");
	ПараметрыФормы.Вставить("ЗаголовокФормыВыбора",                   НСтр("ru = 'Выберите склады для отбора:'"));
	ПараметрыФормы.Вставить("МассивВыбранныхЗначений",                СформироватьМассивВыбранныхЗначений(ПараметрыФормы));
	ПараметрыФормы.Вставить("ПараметрыВнешнегоСоединения",            Неопределено);
	ПараметрыФормы.Вставить("КоллекцияФильтров",                      КоллекцияФильтров);

	ОткрытьФорму("ПланОбмена.ОбменРозницаУправлениеНебольшойФирмой.Форма.ФормаВыбораДополнительныхУсловий",
		ПараметрыФормы,
		ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокВыбранныхВидовЦенНажатие(Элемент)
	КоллекцияФильтров = Неопределено;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ИмяЭлементаФормыДляЗаполнения",          "ВидыЦен");
	ПараметрыФормы.Вставить("ИмяРеквизитаЭлементаФормыДляЗаполнения", "ВидЦен");
	ПараметрыФормы.Вставить("ИмяТаблицыВыбора",                       "Справочник.ВидыЦен");
	ПараметрыФормы.Вставить("ЗаголовокФормыВыбора",                   НСтр("ru = 'Выберите виды цен для отбора:'"));
	ПараметрыФормы.Вставить("МассивВыбранныхЗначений",                СформироватьМассивВыбранныхЗначений(ПараметрыФормы));
	ПараметрыФормы.Вставить("ПараметрыВнешнегоСоединения",            Неопределено);
	ПараметрыФормы.Вставить("КоллекцияФильтров",                      КоллекцияФильтров);

	ОткрытьФорму("ПланОбмена.ОбменРозницаУправлениеНебольшойФирмой.Форма.ФормаВыбораДополнительныхУсловий",
		ПараметрыФормы,
		ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборПоОрганизациямПриИзменении(Элемент)
	УправлениеФормой();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборПоСкладамПриИзменении(Элемент)
	УправлениеФормой();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборПоВидамЦенПриИзменении(Элемент)
	УправлениеФормой();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СформироватьМассивВыбранныхЗначений(ПараметрыФормы)
	
	ТабличнаяЧасть           = Объект[ПараметрыФормы.ИмяЭлементаФормыДляЗаполнения];
	ТаблицаВыбранныхЗначений = ТабличнаяЧасть.Выгрузить(,ПараметрыФормы.ИмяРеквизитаЭлементаФормыДляЗаполнения);
	МассивВыбранныхЗначений  = ТаблицаВыбранныхЗначений.ВыгрузитьКолонку(ПараметрыФормы.ИмяРеквизитаЭлементаФормыДляЗаполнения);
	
	Возврат МассивВыбранныхЗначений;

КонецФункции

&НаСервере
Процедура ОбновитьНаименованиеКомандФормы()
	
	Если Объект.Организации.Количество() > 0 Тогда
		ВыбранныеЭлементы = Объект.Организации.Выгрузить().ВыгрузитьКолонку("Организация");
		НовыйЗаголовок = СтрСоединить(ВыбранныеЭлементы,", ");
	Иначе
		НовыйЗаголовок = НСтр("ru = 'Выбрать организации'");
	КонецЕсли;
	Элементы.ОткрытьСписокВыбранныхОрганизаций.Заголовок = НовыйЗаголовок;
	
	Если Объект.Склады.Количество() > 0 Тогда
		ВыбранныеЭлементы = Объект.Склады.Выгрузить().ВыгрузитьКолонку("Склад");
		НовыйЗаголовок = СтрСоединить(ВыбранныеЭлементы,", ");
	Иначе
		НовыйЗаголовок = НСтр("ru = 'Выбрать магазины'");
	КонецЕсли;
	Элементы.ОткрытьСписокВыбранныхСкладов.Заголовок = НовыйЗаголовок;
	
	Если Объект.ВидыЦен.Количество() > 0 Тогда
		ВыбранныеЭлементы = Объект.ВидыЦен.Выгрузить().ВыгрузитьКолонку("ВидЦен");
		НовыйЗаголовок = СтрСоединить(ВыбранныеЭлементы,", ");
	Иначе
		НовыйЗаголовок = НСтр("ru = 'Выбрать виды цен'");
	КонецЕсли;
	Элементы.ОткрытьСписокВыбранныхВидовЦен.Заголовок = НовыйЗаголовок;
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеФормой()
	
	Элементы.ИспользоватьОтборПоОрганизациям.Видимость   = ИспользоватьНесколькоОрганизаций;
	Элементы.ОткрытьСписокВыбранныхОрганизаций.Видимость = ИспользоватьНесколькоОрганизаций;
	
	Элементы.ОткрытьСписокВыбранныхОрганизаций.Доступность = Объект.ИспользоватьОтборПоОрганизациям;
	Элементы.ОткрытьСписокВыбранныхСкладов.Доступность     = Объект.ИспользоватьОтборПоСкладам;
	Элементы.ОткрытьСписокВыбранныхВидовЦен.Доступность    = Объект.ИспользоватьОтборПоВидамЦен;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеОбъекта(СтруктураПараметров)
	
	Объект[СтруктураПараметров.ИмяТаблицыДляЗаполнения].Очистить();
	
	СписокВыбранныхЗначений = ПолучитьИзВременногоХранилища(СтруктураПараметров.АдресТаблицыВоВременномХранилище);
		Если СписокВыбранныхЗначений.Количество() > 0 Тогда
		СписокВыбранныхЗначений.Колонки.Представление.Имя = СтруктураПараметров.ИмяКолонкиДляЗаполнения;
		Объект[СтруктураПараметров.ИмяТаблицыДляЗаполнения].Загрузить(СписокВыбранныхЗначений);
	КонецЕсли;
	
	ОбновитьНаименованиеКомандФормы();
	
КонецПроцедуры

#КонецОбласти




