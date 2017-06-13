﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СтатистикаИспользованияФормКлиент.ПроверитьЗаписатьСтатистикуКоманды(
		"СоздатьНаОсновании.Событие",
		ЭтотОбъект.ВладелецФормы,
		?(ТипЗнч(ЭтотОбъект.Основание) = Тип("Неопределено"), Неопределено, ЭтотОбъект.Основание.ОснованиеЗаполнения)
	);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокВидовОперацийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтрокаТаблицы = СписокВидовОпераций.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	ОткрытьДокументВида(СтрокаТаблицы.Значение);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьДокумент(Команда)
	
	СтрокаТаблицы = Элементы.СписокВидовОпераций.ТекущиеДанные;
	
	Если НЕ СтрокаТаблицы = Неопределено Тогда
		
		ОткрытьДокументВида(СтрокаТаблицы.Значение);
		
	КонецЕсли; 
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ЗначениеКопирования = Параметры.ЗначениеКопирования;
	ЗначенияЗаполнения  = Параметры.ЗначенияЗаполнения;
	Основание           = ?(Параметры.Основание = Неопределено, Неопределено, Новый Структура("ОснованиеЗаполнения", Параметры.Основание));
	
	Параметры.ЗначениеКопирования	= Неопределено;
	Параметры.ЗначенияЗаполнения	= Неопределено;
	Параметры.Основание				= Неопределено;
	
	ФормыДокумента = Новый ФиксированноеСоответствие(
		Документы.Событие.ПолучитьСоответствиеВидовОперацийФормам());
		
	ВидыОпераций = ПолучитьСписокВидовОпераций();
	Для Каждого ВидОперации Из ВидыОпераций Цикл
		НоваяОперация = СписокВидовОпераций.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяОперация, ВидОперации);
	КонецЦикла;
	
	Если ЗначениеЗаполнено(Объект.ТипСобытия) Тогда
		ВыделенныйЭлементСписка = СписокВидовОпераций.НайтиПоЗначению(Объект.ТипСобытия);
		Если ВыделенныйЭлементСписка <> Неопределено Тогда
			Элементы.СписокВидовОпераций.ТекущаяСтрока = ВыделенныйЭлементСписка.ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСписокВидовОпераций()

	СписокВидовОпераций = Новый СписокЗначений;
	
	ЗначенияПеречисления = Метаданные.Перечисления.ТипыСобытий.ЗначенияПеречисления;
	Для Каждого ЗначениеПеречисления Из ЗначенияПеречисления Цикл
		Если ВРег(Лев(ЗначениеПеречисления.Имя, 7)) = ВРег("Удалить") Тогда
			Продолжить;
		КонецЕсли;
		ТекущийВидОперации = Перечисления.ТипыСобытий[ЗначениеПеречисления.Имя];
		СписокВидовОпераций.Добавить(ТекущийВидОперации, Строка(ТекущийВидОперации));
	КонецЦикла;
	
	Возврат СписокВидовОпераций;

КонецФункции

&НаКлиенте
Процедура ОткрытьДокументВида(ВыбранныйТипСобытия)
	
	Если Основание = Неопределено Тогда
		ЗначенияЗаполнения.Вставить("ТипСобытия",		ВыбранныйТипСобытия);
	Иначе
		Основание.Вставить("ТипСобытия",				ВыбранныйТипСобытия);
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Ключ",                Параметры.Ключ);
	СтруктураПараметров.Вставить("ЗначениеКопирования", ЗначениеКопирования);
	СтруктураПараметров.Вставить("ЗначенияЗаполнения",  ЗначенияЗаполнения);
	СтруктураПараметров.Вставить("Основание",           Основание);
	
	Модифицированность = Ложь;
	Закрыть();
	
	ОткрытьФорму("Документ.Событие.Форма." + ФормыДокумента[ВыбранныйТипСобытия], СтруктураПараметров, ВладелецФормы);
	
КонецПроцедуры

#КонецОбласти
