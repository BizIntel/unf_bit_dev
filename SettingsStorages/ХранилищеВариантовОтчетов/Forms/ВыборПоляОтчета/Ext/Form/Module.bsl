﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ПеременныеКлиента;

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// СОБЫТИЯ ФОРМЫ

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.Свойство("КомпоновщикНастроек", КомпоновщикНастроек) Тогда
		ВызватьИсключение НСтр("ru = 'Не передан служебный параметр ""КомпоновщикНастроек"".'");
	КонецЕсли;
	Если Не Параметры.Свойство("Режим", Режим) Тогда
		ВызватьИсключение НСтр("ru = 'Не передан служебный параметр ""Режим"".'");
	КонецЕсли;
	Если Режим = "СоставГруппировки" Или Режим = "СтруктураВарианта" Тогда
		ИмяТаблицы = "ПоляГруппировки";
	ИначеЕсли Режим = "Отборы" Или Режим = "ВыбранныеПоля" Или Режим = "Сортировка" Или Режим = "ПоляГруппировки" Тогда
		ИмяТаблицы = Режим;
	Иначе
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Некорректное значение параметра ""Режим"": ""%1"".'"), Строка(Режим));
	КонецЕсли;
	Если Не Параметры.Свойство("НастройкиОтчета", НастройкиОтчета) Тогда
		ВызватьИсключение НСтр("ru = 'Не передан служебный параметр ""НастройкиОтчета"".'");
	КонецЕсли;
	Если Параметры.Свойство("ИдентификаторТекущегоУзлаКД", ИдентификаторТекущегоУзлаКД)
		И ИдентификаторТекущегоУзлаКД <> Неопределено Тогда
		ТекущийУзелКД = КомпоновщикНастроек.Настройки.ПолучитьОбъектПоИдентификатору(ИдентификаторТекущегоУзлаКД);
		Если ТипЗнч(ТекущийУзелКД) = Тип("КоллекцияЭлементовСтруктурыТаблицыКомпоновкиДанных")
			Или ТипЗнч(ТекущийУзелКД) = Тип("КоллекцияЭлементовСтруктурыДиаграммыКомпоновкиДанных")
			Или ТипЗнч(ТекущийУзелКД) = Тип("ТаблицаКомпоновкиДанных")
			Или ТипЗнч(ТекущийУзелКД) = Тип("ДиаграммаКомпоновкиДанных") Тогда
			ИдентификаторТекущегоУзлаКД = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Если ИмяТаблицы = "ПоляГруппировки" Тогда
		ЭлементыДерева = ПоляГруппировки.ПолучитьЭлементы();
		ПоляГруппировкиРазвернутьСтроку(ТаблицаКД(ЭтотОбъект), ЭлементыДерева);
		Если Режим = "СтруктураВарианта" Тогда
			СтрокаДерева = ЭлементыДерева.Добавить();
			СтрокаДерева.Представление  = НСтр("ru = '<Детальные записи>'");
			СтрокаДерева.ИндексКартинки = ВариантыОтчетовКлиентСервер.ИндексПиктограммыНастроекОтчета("Элемент", Истина, Ложь);
		КонецЕсли;
	КонецЕсли;
	
	ПолеКД = Неопределено;
	Параметры.Свойство("ПолеКД", ПолеКД);
	Если ПолеКД <> Неопределено Тогда
		ТаблицаКД = ТаблицаКД(ЭтотОбъект);
		ДоступноеПолеКД = ТаблицаКД.НайтиПоле(ПолеКД);
		Если ДоступноеПолеКД <> Неопределено Тогда
			Элементы[ИмяТаблицы + "Таблица"].ТекущаяСтрока = ТаблицаКД.ПолучитьИдентификаторПоОбъекту(ДоступноеПолеКД);
		КонецЕсли;
	КонецЕсли;
	
	Элементы.Страницы.ТекущаяСтраница = Элементы[ИмяТаблицы + "Страница"];
	
	Источник = Новый ИсточникДоступныхНастроекКомпоновкиДанных(НастройкиОтчета.АдресСхемы);
	КомпоновщикНастроек.Инициализировать(Источник);
	
	ЗакрыватьПриВыборе = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПеременныеКлиента = Новый Структура;
	ПеременныеКлиента.Вставить("РазворачиваемыеУзлы", Новый Массив);
	ПеременныеКлиента.Вставить("КоличествоРазворачиваемых", 0);
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// СОБЫТИЯ ЭЛЕМЕНТОВ

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Выбрать(Команда)
	ВыбратьИЗакрыть();
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// СОБЫТИЯ ТАБЛИЦЫ ОтборыТаблица

#Область ОбработчикиСобытийЭлементовТаблицыФормыОтборыТаблица

&НаКлиенте
Процедура ОтборыТаблицаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыбратьИЗакрыть();
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// СОБЫТИЯ ТАБЛИЦЫ ВыбранныеПоляТаблица

#Область ОбработчикиСобытийЭлементовТаблицыФормыВыбранныеПоляТаблица

&НаКлиенте
Процедура ВыбранныеПоляТаблицаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыбратьИЗакрыть();
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// СОБЫТИЯ ТАБЛИЦЫ СортировкаТаблица

#Область ОбработчикиСобытийЭлементовТаблицыФормыСортировкаТаблица

&НаКлиенте
Процедура СортировкаТаблицаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыбратьИЗакрыть();
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// СОБЫТИЯ ТАБЛИЦЫ ПоляГруппировки

#Область ОбработчикиСобытийЭлементовТаблицыФормыПоляГруппировки

&НаКлиенте
Процедура ПоляГруппировкиТаблицаПередРазворачиванием(ТаблицаЭлемент, ИдентификаторСтроки, Отказ)
	Если ПеременныеКлиента = Неопределено Или ПеременныеКлиента.КоличествоРазворачиваемых > 100 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	СтрокаДерева = ПоляГруппировки.НайтиПоИдентификатору(ИдентификаторСтроки);
	Если СтрокаДерева = Неопределено Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	Если СтрокаДерева.НадоПрочитатьВложенные Тогда // Не все узлы надо разворачивать.
		ПеременныеКлиента.КоличествоРазворачиваемых = ПеременныеКлиента.КоличествоРазворачиваемых + 1;
		ПеременныеКлиента.РазворачиваемыеУзлы.Добавить(ИдентификаторСтроки);
		ПодключитьОбработчикОжидания("РазвернутьСтрокиПолейГруппировки", 0.1, Истина); // Защита от зависания по Ctrl_Shift_+.
		СтрокаДерева.ПолучитьЭлементы().Очистить(); // Чтобы пользователь не видел промежуточных эффектов.
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПоляГруппировкиТаблицаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыбратьИЗакрыть();
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура ВыбратьИЗакрыть()
	ТаблицаЭлемент = Элементы[ИмяТаблицы + "Таблица"];
	Если ИмяТаблицы = "ПоляГруппировки" Тогда
		СтрокаДерева = ТаблицаЭлемент.ТекущиеДанные;
		Если СтрокаДерева = Неопределено Тогда
			Возврат;
		КонецЕсли;
		ИдентификаторКД = СтрокаДерева.ИдентификаторКД;
	Иначе
		ИдентификаторКД = ТаблицаЭлемент.ТекущаяСтрока;
	КонецЕсли;
	Если ИдентификаторКД = Неопределено Тогда
		Если ИмяТаблицы = "ПоляГруппировки" Тогда
			ДоступноеПолеКД = "<>";
		Иначе
			Возврат;
		КонецЕсли;
	Иначе
		ДоступноеПолеКД = ТаблицаКД(ЭтотОбъект).ПолучитьОбъектПоИдентификатору(ИдентификаторКД);
		Если ДоступноеПолеКД = Неопределено Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	Если ТипЗнч(ДоступноеПолеКД) = Тип("ДоступноеПолеКомпоновкиДанных")
		Или ТипЗнч(ДоступноеПолеКД) = Тип("ДоступноеПолеОтбораКомпоновкиДанных") Тогда
		Если ДоступноеПолеКД.Папка Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Выберите элемент'"));
			Возврат;
		КонецЕсли;
	КонецЕсли;
	ОповеститьОВыборе(ДоступноеПолеКД);
	Закрыть(ДоступноеПолеКД);
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьСтрокиПолейГруппировки()
	РазвернутьСтрокиПолейГруппировкиВызовСервера(ПеременныеКлиента.РазворачиваемыеУзлы);
	ПеременныеКлиента.РазворачиваемыеУзлы.Очистить();
	ПеременныеКлиента.КоличествоРазворачиваемых = 0;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Клиент, Сервер

&НаКлиентеНаСервереБезКонтекста
Функция ТаблицаКД(ЭтотОбъект)
	Если ЭтотОбъект.ИмяТаблицы = "Отборы" Тогда
		Возврат ЭтотОбъект.КомпоновщикНастроек.Настройки.Отбор.ДоступныеПоляОтбора;
	ИначеЕсли ЭтотОбъект.ИмяТаблицы = "ВыбранныеПоля" Тогда
		Возврат ЭтотОбъект.КомпоновщикНастроек.Настройки.Выбор.ДоступныеПоляВыбора;
	ИначеЕсли ЭтотОбъект.ИмяТаблицы = "Сортировка" Тогда
		Возврат ЭтотОбъект.КомпоновщикНастроек.Настройки.Порядок.ДоступныеПоляПорядка;
	ИначеЕсли ЭтотОбъект.ИмяТаблицы = "ПоляГруппировки" Тогда
		Если ЭтотОбъект.ИдентификаторТекущегоУзлаКД = Неопределено Тогда
			ТекущийУзелКД = ЭтотОбъект.КомпоновщикНастроек.Настройки;
		Иначе
			ТекущийУзелКД = ЭтотОбъект.КомпоновщикНастроек.Настройки.ПолучитьОбъектПоИдентификатору(ЭтотОбъект.ИдентификаторТекущегоУзлаКД);
		КонецЕсли;
		Если ТипЗнч(ТекущийУзелКД) = Тип("НастройкиКомпоновкиДанных") Тогда
			Возврат ТекущийУзелКД.ДоступныеПоляГруппировок;
		Иначе
			Возврат ТекущийУзелКД.ПоляГруппировки.ДоступныеПоляПолейГруппировок;
		КонецЕсли;
	КонецЕсли;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура РазвернутьСтрокиПолейГруппировкиКлиентСервер(ТаблицаКД, ПоляГруппировки, РазворачиваемыеУзлы)
	Итого = 0;
	Для Каждого ИдентификаторСтроки Из РазворачиваемыеУзлы Цикл
		СтрокаДерева = ПоляГруппировки.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если СтрокаДерева = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если Не СтрокаДерева.НадоПрочитатьВложенные Тогда
			Продолжить;
		КонецЕсли;
		СтрокаДерева.НадоПрочитатьВложенные = Ложь;
		ДоступноеПолеКД = ТаблицаКД.ПолучитьОбъектПоИдентификатору(СтрокаДерева.ИдентификаторКД);
		СтрокиДерева = СтрокаДерева.ПолучитьЭлементы();
		СтрокиДерева.Очистить();
		ПоляГруппировкиРазвернутьСтроку(ТаблицаКД, СтрокиДерева, ДоступноеПолеКД, Итого);
	КонецЦикла;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПоляГруппировкиРазвернутьСтроку(ТаблицаКД, СтрокиДерева, ДоступноеПолеКДРодитель = Неопределено, Итого = 0)
	Если ДоступноеПолеКДРодитель = Неопределено Тогда
		ДоступноеПолеКДРодитель = ТаблицаКД;
		Префикс = "";
	Иначе
		Префикс = ДоступноеПолеКДРодитель.Заголовок + ".";
	КонецЕсли;
	
	Итого = Итого + ДоступноеПолеКДРодитель.Элементы.Количество();
	ПодсчитыватьКоличество = (Итого <= 100);
	Для Каждого ДоступноеПолеКД Из ДоступноеПолеКДРодитель.Элементы Цикл
		Если ТипЗнч(ДоступноеПолеКД) = Тип("ДоступноеПолеКомпоновкиДанных") Тогда
			СтрокаДерева = СтрокиДерева.Добавить();
			СтрокаДерева.Представление = СтрЗаменить(ДоступноеПолеКД.Заголовок, Префикс, "");
			СтрокаДерева.ИдентификаторКД = ТаблицаКД.ПолучитьИдентификаторПоОбъекту(ДоступноеПолеКД);
			НадоПрочитатьВложенные = Неопределено;
			Если ДоступноеПолеКД.Таблица Тогда
				Тип = "Таблица";
			ИначеЕсли ДоступноеПолеКД.Ресурс Тогда
				Тип = "Ресурс";
			ИначеЕсли ДоступноеПолеКД.Папка Тогда
				Тип = "Папка";
			Иначе
				Тип = "Элемент";
			КонецЕсли;
			СтрокаДерева.ИндексКартинки = ВариантыОтчетовКлиентСервер.ИндексПиктограммыНастроекОтчета(Тип, Ложь, Ложь);
			
			// Вычисление коллекции "ДоступноеПолеКД.Элементы" в некоторых случаях делает неявный серверный вызов.
			Если ПодсчитыватьКоличество Тогда
				СтрокаДерева.НадоПрочитатьВложенные = ДоступноеПолеКД.Элементы.Количество() > 0;
			Иначе
				СтрокаДерева.НадоПрочитатьВложенные = Истина;
			КонецЕсли;
			Если СтрокаДерева.НадоПрочитатьВложенные Тогда
				СтрокаДерева.ПолучитьЭлементы().Добавить().Представление = "...";
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера, Сервер

&НаСервере
Процедура РазвернутьСтрокиПолейГруппировкиВызовСервера(РазворачиваемыеУзлы)
	РазвернутьСтрокиПолейГруппировкиКлиентСервер(ТаблицаКД(ЭтотОбъект), ПоляГруппировки, РазворачиваемыеУзлы);
КонецПроцедуры

#КонецОбласти