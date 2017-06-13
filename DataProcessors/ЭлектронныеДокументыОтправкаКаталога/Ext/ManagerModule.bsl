﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ

Функция ПолучитьПустуюСтруктуруРезультата() Экспорт
	
	Структура = Новый Структура;
	Структура.Вставить("ТаблицаТоваров", 							 Неопределено);
	Структура.Вставить("СоответствиеПолейСКДКолонкамТаблицыТоваров", Новый Соответствие);
	
	Возврат Структура;
	
КонецФункции // ПолучитьПустуюСтруктуруРезультата()

Функция ПолучитьПустуюСтруктуруНастроек() Экспорт
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ОбязательныеПоля"   , 			  Новый Массив);
	СтруктураНастроек.Вставить("ПараметрыДанных"    , 			  Новый Структура);
	СтруктураНастроек.Вставить("КомпоновщикНастроек", 			  Неопределено); // Отбор
	СтруктураНастроек.Вставить("ИмяМакетаСхемыКомпоновкиДанных" , Неопределено);
	
	Возврат СтруктураНастроек;
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// РАБОТА С СКД

// Среди элементов полей СКД найти поле по имени.
//
Функция НайтиПолеСКДПоИмени(Элементы, Имя)
	
	Для Каждого Элемент Из Элементы Цикл
		Если ВРЕГ(Строка(Элемент.Поле)) = ВРЕГ(Имя) Тогда
			Возврат Элемент;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции // НайтиПолеСКДПоИмени()

// Найти поле СКД по полному имени.
//
Функция НайтиПолеСКДПоПолномуИмени(Элементы, ПолноеИмя) Экспорт

	масЧастейИмен = ИзПолногоИмениПоляПолучитьЧасти(ПолноеИмя);
	колЧастей 	  = масЧастейИмен.Количество();
	
	текИмя = масЧастейИмен[0];
	Поле   = НайтиПолеСКДПоИмени(Элементы, текИмя);
	
	Если Поле = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Для Сч = 2 По колЧастей Цикл
		
		текИмя = текИмя + "." + масЧастейИмен[Сч-1];
		Поле   = НайтиПолеСКДПоИмени(Поле.Элементы, текИмя);
		
		Если Поле = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Поле;

КонецФункции // НайтиПолеСКДПоПолномуИмени()

// Полное имя поля разделить по частям
//
Функция ИзПолногоИмениПоляПолучитьЧасти(ПолноеИмя)

	масЧастей = Новый Массив;
	СтрИмя 	  = ПолноеИмя;
	
	Пока НЕ ПустаяСтрока(СтрИмя) Цикл
		
		Если Лев(СтрИмя, 1) = "[" Тогда
			
			Поз = СтрНайти(СтрИмя, "]");
			Если Поз = 0 Тогда
				масЧастей.Добавить(Сред(СтрИмя, 2));
				СтрИмя = "";
			Иначе
				масЧастей.Добавить(Сред(СтрИмя, 1, Поз));
				СтрИмя = Сред(СтрИмя, Поз + 2);
			КонецЕсли;
			
		Иначе
			
			Поз = СтрНайти(СтрИмя, ".");
			Если Поз = 0 Тогда
				масЧастей.Добавить(СтрИмя);
				СтрИмя = "";
			Иначе
				масЧастей.Добавить(Лев(СтрИмя, Поз - 1));
				СтрИмя = Сред(СтрИмя, Поз + 1);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат масЧастей;

КонецФункции // ИзПолногоИмениПоляПолучитьЧасти()


Процедура УстановитьОтборПоТипуЦен(Компоновщик)
	
	ОтборТипЦен = НайтиЭлементОтбораПоИмени(Компоновщик.Настройки.Отбор, "ТипЦен");
	
	Если ОтборТипЦен = Неопределено Тогда
		Возврат; // нет такого отбора в СКД
	КонецЕсли;
	
	Если НЕ ОтборТипЦен.Использование
		ИЛИ ОтборТипЦен.ВидСравнения <> ВидСравненияКомпоновкиДанных.Равно Тогда
		
		Если ОтборТипЦен.Использование Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Нстр("ru = 'Возможен отбор только по одному типу цен. Информация о ценах номенклатуры не заполнена.'"));
		КонецЕсли;
		
		ОтборТипЦен.Использование  = Истина;
		ОтборТипЦен.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ОтборТипЦен.ПравоеЗначение = Справочники.ВидыЦен.ПустаяСсылка();
		
	КонецЕсли;
	
КонецПроцедуры

Функция НайтиЭлементОтбораПоИмени(Отбор, ИмяЭлемента)
	
	ПолеКомпоновки = Новый ПолеКомпоновкиДанных(ИмяЭлемента);
	Результат 	   = Неопределено;
	
	Для Каждого ТекЭлемент Из Отбор.Элементы Цикл
		
		Если ТипЗнч(ТекЭлемент) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			Результат = НайтиЭлементОтбораПоИмени(ТекЭлемент, ИмяЭлемента);
			Если НЕ Результат = Неопределено Тогда
				Прервать;
			КонецЕсли;
		Иначе
			Если ТекЭлемент.ЛевоеЗначение = ПолеКомпоновки Тогда
				Результат = ТекЭлемент;
				Прервать;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ФОРМИРОВАНИЕ ТАБЛИЦЫ

// Функция подготавливает структуру данных, необходимую для печати этикеток и ценников.
//
// Возвращаемое значение:
//  Стрруктура - данные, необходимые для печати этикеток и ценников.
//
Функция ПодготовитьСтруктуруДанных(СтруктураНастроек) Экспорт
	
	СтруктураРезультата = ПолучитьПустуюСтруктуруРезультата();
	
	////////////////////////////////////////////////////////////////////////////////
	// ПОДГОТОВКА СХЕМЫ КОМПОНОВКИ ДАННЫХ И КОМПОНОВЩИКА НАСТРОЕК СКД
	
	// Схема компоновки.
	СхемаКомпоновкиДанных = Обработки.ЭлектронныеДокументыОтправкаКаталога.ПолучитьМакет(СтруктураНастроек.ИмяМакетаСхемыКомпоновкиДанных);
	
	// Подготовка компоновщика макета компоновки данных.
	Компоновщик = Новый КомпоновщикНастроекКомпоновкиДанных;
	Компоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	Компоновщик.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	Компоновщик.Настройки.Отбор.Элементы.Очистить();
	
	// Отбор компоновщика настроек.
	Если СтруктураНастроек.КомпоновщикНастроек <> Неопределено Тогда
		Обработки.ПечатьЭтикетокИЦенников.СкопироватьЭлементы(Компоновщик.Настройки.Отбор, СтруктураНастроек.КомпоновщикНастроек.Настройки.Отбор);
	КонецЕсли;
	
	УстановитьОтборПоТипуЦен(Компоновщик);
	
	// Выбранные поля компоновщика настроек.
	Для Каждого ОбязательноеПоле Из СтруктураНастроек.ОбязательныеПоля Цикл
		ПолеСКД = НайтиПолеСКДПоПолномуИмени(Компоновщик.Настройки.Выбор.ДоступныеПоляВыбора.Элементы, ОбязательноеПоле);
		Если ПолеСКД <> Неопределено Тогда
			ВыбранноеПоле = Компоновщик.Настройки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
			ВыбранноеПоле.Поле = ПолеСКД.Поле;
		КонецЕсли;
	КонецЦикла;
	
	// Компоновка макета компоновки данных.
	КомпоновщикМакета 	  = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Компоновщик.Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	////////////////////////////////////////////////////////////////////////////////
	// ПОДГОТОВКА ВСПОМОГАТЕЛЬНЫХ ДАННЫХ ДЛЯ СОПОСТАВЛЕНИЯ ПОЛЕЙ ШАБЛОНА И СКД
	
	Для Каждого Поле Из МакетКомпоновкиДанных.НаборыДанных.НаборДанных.Поля Цикл
		СтруктураРезультата.СоответствиеПолейСКДКолонкамТаблицыТоваров.Вставить(
			Справочники.ШаблоныЭтикетокИЦенников.ПолучитьИмяПоляВШаблоне(Поле.ПутьКДанным),
			Поле.Имя);
	КонецЦикла;
	
	////////////////////////////////////////////////////////////////////////////////
	// ВЫПОЛНЕНИЕ ЗАПРОСА
	
	Запрос = Новый Запрос(МакетКомпоновкиДанных.НаборыДанных.НаборДанных.Запрос);
	
	// Заполнение параметров с полей отбора компоновщика настроек формы обработки.
	Для Каждого Параметр Из МакетКомпоновкиДанных.ЗначенияПараметров Цикл
		Запрос.Параметры.Вставить(Параметр.Имя, Параметр.Значение);
	КонецЦикла;
	
	СтруктураРезультата.ТаблицаТоваров = Запрос.Выполнить().Выгрузить();
	
	Возврат СтруктураРезультата;
	
КонецФункции // ПодготовитьСтруктуруДанных()

#КонецЕсли