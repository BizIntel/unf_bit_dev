﻿
#Область ПеременныеФормы

&НаКлиенте
Перем УстановкаОсновногоКонтактногоЛицаВыполнена; // Признак успешной установки основного контактного лица из формы контрагента

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат; // Возврат при получении формы для анализа.
	КонецЕсли;
	
	Параметры.Отбор.Свойство("Владелец", КонтрагентВладелец);
	
	Если ЗначениеЗаполнено(КонтрагентВладелец) Тогда
		// Контекстное открытие формы с отбором по контрагенту
	
		АвтоЗаголовок = Ложь;
		Заголовок = НСтр("ru='Контактные лица'") + " """ + КонтрагентВладелец + """";
		
		Список.Параметры.УстановитьЗначениеПараметра("ОсновноеКонтактноеЛицоКонтрагента",
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КонтрагентВладелец, "КонтактноеЛицо"));
		
	Иначе
		// Открытие в общем режиме
		
		Элементы.Владелец.Видимость = Истина;
		Элементы.ПереместитьЭлементВверх.Видимость = Ложь;
		Элементы.ПереместитьЭлементВниз.Видимость = Ложь;
		Список.Параметры.УстановитьЗначениеПараметра("ОсновноеКонтактноеЛицоКонтрагента", Неопределено);
		
	КонецЕсли;
	
	Элементы.ИспользоватьКакОсновной.Видимость = ПравоДоступа("Редактирование", Метаданные.Справочники.Контрагенты);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Недействителен",
		Ложь,
		,
		,
		Не Элементы.ПоказыватьНедействительных.Пометка);
	
	// Установим настройки формы для случая открытия в режиме выбора
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	Элементы.Список.МножественныйВыбор = ?(Параметры.ЗакрыватьПриВыборе = Неопределено, Ложь, Не Параметры.ЗакрыватьПриВыборе);
	Если Параметры.РежимВыбора Тогда
		КлючНазначенияИспользования = "ВыборПодбор";
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	Иначе
		КлючНазначенияИспользования = "Список";
	КонецЕсли;
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "УстановкаОсновногоКонтактногоЛицаВыполнена" Тогда
		УстановкаОсновногоКонтактногоЛицаВыполнена = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если ТипЗнч(Элементы.Список.ТекущаяСтрока) <> Тип("СтрокаГруппировкиДинамическогоСписка")
		И Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		
		Элементы.ИспользоватьКакОсновной.Доступность = Не Элементы.Список.ТекущиеДанные.ЭтоОсновноеКонтактноеЛицо;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИспользоватьКакОсновной(Команда)
	
	Если ТипЗнч(Элементы.Список.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка")
		Или Элементы.Список.ТекущиеДанные = Неопределено
		Или Элементы.Список.ТекущиеДанные.ЭтоОсновноеКонтактноеЛицо Тогда
		
		Возврат;
	КонецЕсли;
	
	НовоеОсновноеКонтактноеЛицо = Элементы.Список.ТекущиеДанные.Ссылка;
	
	// Если открыта форма контрагента, то изменение основного контактного лица выполняем в ней
	УстановкаОсновногоКонтактногоЛицаВыполнена = Ложь;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Контрагент", Элементы.Список.ТекущиеДанные.Владелец);
	СтруктураПараметров.Вставить("НовоеОсновноеКонтактноеЛицо", НовоеОсновноеКонтактноеЛицо);
	
	Оповестить("УстановкаОсновногоКонтактногоЛица", СтруктураПараметров, ЭтотОбъект);
	
	// Если форма контрагента закрыта, то запишем основной договор контрагента самостоятельно
	Если Не УстановкаОсновногоКонтактногоЛицаВыполнена Тогда
		ЗаписатьОсновноеКонтактноеЛицо(СтруктураПараметров);
	КонецЕсли;
	
	// Обновим динамический список
	Если ЗначениеЗаполнено(КонтрагентВладелец) Тогда
		Список.Параметры.УстановитьЗначениеПараметра("ОсновноеКонтактноеЛицоКонтрагента", НовоеОсновноеКонтактноеЛицо);
	Иначе
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьНедействительных(Команда)
	
	Элементы.ПоказыватьНедействительных.Пометка = Не Элементы.ПоказыватьНедействительных.Пометка;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Недействителен",
		Ложь,
		,
		,
		Не Элементы.ПоказыватьНедействительных.Пометка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// 1. Недействительное контактное лицо выделяем серым
	НовоеУсловноеОформление = Список.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы.Добавить();
	
	Оформление = НовоеУсловноеОформление.Оформление.Элементы.Найти("ЦветТекста");
	Оформление.Значение 		= ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет;
	Оформление.Использование 	= Истина;
	
	Отбор = НовоеУсловноеОформление.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Отбор.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
	Отбор.Использование 	= Истина;
	Отбор.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("Недействителен");
	Отбор.ПравоеЗначение 	= Истина;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьОсновноеКонтактноеЛицо(СтруктураПараметров)
	
	КонтрагентОбъект = СтруктураПараметров.Контрагент.ПолучитьОбъект();
	КонтрагентУспешноЗаблокирован = Истина;
	
	Попытка
		КонтрагентОбъект.Заблокировать();
	Исключение
		
		КонтрагентУспешноЗаблокирован = Ложь;
		
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Не удалось заблокировать %1: %2, для изменения основного банковского счета, по причине:
				|%3'", Метаданные.ОсновнойЯзык.КодЯзыка), 
				СтруктураПараметров.Контрагент.Метаданные.ПредставлениеОбъекта, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(ТекстСообщения, УровеньЖурналаРегистрации.Предупреждение,, КонтрагентОбъект, ОписаниеОшибки());
		
	КонецПопытки;
	
	// Если удалось заблокировать, изменим банковский счет по умолчанию у контрагента/организации
	Если КонтрагентУспешноЗаблокирован Тогда
		КонтрагентОбъект.КонтактноеЛицо = СтруктураПараметров.НовоеОсновноеКонтактноеЛицо;
		КонтрагентОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.НастройкаПорядкаЭлементов
&НаКлиенте
Процедура ПереместитьЭлементВверх(Команда)
	НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВверхВыполнить(Список, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьЭлементВниз(Команда)
	НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВнизВыполнить(Список, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.НастройкаПорядкаЭлементов

#КонецОбласти
