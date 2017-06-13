﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура загружает стандартные значения из макета с именем "СтандартныеЗначения".
// Имеет смысл заполнять значения из макета:
//  - при обновлении конфигурации (когда подключение к интернету может занять много времени);
//  - при первоначальном заполнении пустой базы, когда не заполнены параметры, логины и пароли для доступа к веб-сервисам обновлений.
//
// Параметры:
//  Нет.
//
Процедура ЗагрузитьСтандартныеЗначения() Экспорт

	ТипСоответствие = Тип("Соответствие");
	ТипСтрока = Тип("Строка");

	ОбъектМетаданных = Справочники.ЗначенияКатегорийНовостей; // Переопределение
	ИмяОбъектаМетаданных = "Справочники.ЗначенияКатегорийНовостей"; // Переопределение
	ИмяСвойства = "CatalogObject_ЗначенияКатегорийНовостей"; // Переопределение

	Т0Начало = ТекущаяУниверсальнаяДатаВМиллисекундах();
	ИдентификаторШага = НСтр("ru='Новости. Сервис и регламент. Загрузка стандартных значений. %ИмяСвойства%. Начало'");
	ИдентификаторШага = СтрЗаменить(ИдентификаторШага, "%ИмяСвойства%", ИмяСвойства);
	ТекстСообщения = НСтр("ru='Начало загрузки стандартных значений
		|Время начала (мс): %ТНачало%
		|'");
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТНачало%", Т0Начало);
	ИнтернетПоддержкаПользователей.ЗаписатьСообщениеВЖурналРегистрации(
		НСтр("ru='БИП:Новости.Сервис и регламент'"), // ИмяСобытия
		ИдентификаторШага, // ИдентификаторШага
		УровеньЖурналаРегистрации.Информация, // УровеньЖурналаРегистрации.*
		ОбъектМетаданных, // ОбъектМетаданных
		, // Данные
		ТекстСообщения, // Комментарий
		ОбработкаНовостейВызовСервера.ВестиПодробныйЖурналРегистрации()); // ВестиПодробныйЖурналРегистрации

	СодержимоеМакета = ОбъектМетаданных.ПолучитьМакет("СтандартныеЗначения").ПолучитьТекст();
	ПоставляемыеДанныеОбъекта = Новый Соответствие;
	ПоставляемыеДанныеОбъекта.Вставить(
		"" + ИмяОбъектаМетаданных + ":СтандартныеЗначения", // Идентификатор.
		СодержимоеМакета);
	ОбработкаНовостейПереопределяемый.ПолучитьДополнительныеСтандартныеЗначенияКлассификаторов(ИмяОбъектаМетаданных, ПоставляемыеДанныеОбъекта);
	ЛогЗагрузки = "";
	Если ТипЗнч(ПоставляемыеДанныеОбъекта) = ТипСоответствие Тогда
		Для Каждого СтрокаСтандартныхЗначений Из ПоставляемыеДанныеОбъекта Цикл
			Если (ТипЗнч(СтрокаСтандартныхЗначений.Значение) = ТипСтрока)
					И (НЕ ПустаяСтрока(СтрокаСтандартныхЗначений.Значение)) Тогда
				ЕстьОшибки = Ложь;
				Попытка
					ЛогЗагрузки = ЛогЗагрузки
						+ СтрШаблон(
							НСтр("ru='Попытка загрузки стандартных значений из строки (первые 2000 символов):
								|%1
								|'"),
							Лев(СтрокаСтандартныхЗначений.Значение, 2000));
					ЧтениеХМЛ = Новый ЧтениеXML;
					ЧтениеХМЛ.УстановитьСтроку(СтрокаСтандартныхЗначений.Значение);
					ЧтениеХМЛ.Прочитать();
				Исключение
					ИнформацияОбОшибке = ИнформацияОбОшибке();
					ЛогЗагрузки = ЛогЗагрузки
						+ СтрШаблон(
							НСтр("ru='Ошибка загрузки стандартных значений из строки по причине:
								|%1
								|'"),
							ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
					ЕстьОшибки = Истина;
				КонецПопытки;
				Если ЕстьОшибки <> Истина Тогда
					ХМЛТип = ПолучитьXMLТип(ЧтениеХМЛ);
					Если (НРег(ХМЛТип.ИмяТипа) = НРег("DefaultData")) Тогда // И (ВРег(ХМЛТип.URIПространстваИмен)=ВРег("http://v8.1c.ru/8.1/data/enterprise/current-config"))
						ОбъектХДТО = ФабрикаXDTO.ПрочитатьXML(ЧтениеХМЛ);
						СвойствоОбъект = ОбъектХДТО.Свойства().Получить(ИмяСвойства);
						Если ТипЗнч(СвойствоОбъект) = Тип("СвойствоXDTO") Тогда
							Если (СвойствоОбъект.ВерхняяГраница = -1) ИЛИ (СвойствоОбъект.ВерхняяГраница > 1) Тогда
								СписокХДТО = ОбъектХДТО.ПолучитьСписок(СвойствоОбъект);
								Для каждого лкТекущийОбъект Из СписокХДТО Цикл
									ЗагрузитьСтандартноеЗначение(лкТекущийОбъект, ОбъектМетаданных, ИмяСвойства, ЛогЗагрузки);
								КонецЦикла;
							ИначеЕсли (СвойствоОбъект.НижняяГраница = 1) И (СвойствоОбъект.ВерхняяГраница = 1) Тогда
								ЗагрузитьСтандартноеЗначение(ОбъектХДТО.Получить(СвойствоОбъект), ОбъектМетаданных, ИмяСвойства, ЛогЗагрузки);
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	Т0Конец = ТекущаяУниверсальнаяДатаВМиллисекундах();
	Т0Длительность = Т0Конец - Т0Начало;
	ИдентификаторШага = НСтр("ru='Новости. Сервис и регламент. Загрузка стандартных значений. %ИмяСвойства%. Конец'");
	ИдентификаторШага = СтрЗаменить(ИдентификаторШага, "%ИмяСвойства%", ИмяСвойства);
	ТекстСообщения = НСтр("ru='Окончание загрузки стандартных значений
		|Лог загрузки:
		|%ЛогЗагрузки%
		|Время начала (мс): %ТНачало%
		|Время окончания (мс): %ТКонец%
		|Длительность (мс): %ТДлительность%
		|'");
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЛогЗагрузки%", ЛогЗагрузки);
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТНачало%", Т0Начало);
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТКонец%", Т0Конец);
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТДлительность%", Т0Длительность);
	ИнтернетПоддержкаПользователей.ЗаписатьСообщениеВЖурналРегистрации(
		НСтр("ru='БИП:Новости.Сервис и регламент'"), // ИмяСобытия
		ИдентификаторШага, // ИдентификаторШага
		УровеньЖурналаРегистрации.Информация, // УровеньЖурналаРегистрации.*
		ОбъектМетаданных, // ОбъектМетаданных
		Т0Длительность, // Данные
		ТекстСообщения, // Комментарий
		ОбработкаНовостейВызовСервера.ВестиПодробныйЖурналРегистрации()); // ВестиПодробныйЖурналРегистрации

КонецПроцедуры

// Процедура загружает стандартное значение из макета с именем "СтандартныеЗначения".
//
// Параметры:
//  ОбъектХДТО       - Объект ХДТО - загружаемый объект;
//  ОбъектМетаданных - Объект метаданных;
//  ИмяСвойства      - Строка - имя свойства;
//  ЛогЗагрузки      - Строка - сюда будет писаться состояние загрузки данных.
//
Процедура ЗагрузитьСтандартноеЗначение(ОбъектХДТО, ОбъектМетаданных, ИмяСвойства, ЛогЗагрузки)

	Попытка
		// Если объект был загружен ранее (есть другой объект с таким же кодом), то подставить
		//  в создаваемый объект ссылку на созданный ранее элемент.
		НайденныйЭлемент = ОбъектМетаданных.НайтиПоКоду(ОбъектХДТО.Code);
		Если НайденныйЭлемент.Пустая() Тогда
			// Нет ранее созданных элементов с таким же кодом - оставить как есть.
			СтрокаЛогаЗагрузки = СтрШаблон(
				НСтр("ru='Создание: %1'"),
				СокрЛП(ОбъектХДТО.Code));
		Иначе
			// Подменить на ранее созданный элемент с таким же кодом.
			ОбъектХДТО.Ref = НайденныйЭлемент.Ссылка;
			СтрокаЛогаЗагрузки = СтрШаблон(
				НСтр("ru='Изменение: %1, %2'"),
				СокрЛП(НайденныйЭлемент.Код),
				СокрЛП(НайденныйЭлемент.Наименование));
		КонецЕсли;
		ТекущийОбъект = СериализаторXDTO.ПрочитатьXDTO(ОбъектХДТО);
		ТекущийОбъект.Записать();
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ИдентификаторШага = НСтр("ru='Новости. Сервис и регламент. Загрузка стандартных значений. %ИмяСвойства%. Ошибка'");
		ИдентификаторШага = СтрЗаменить(ИдентификаторШага, "%ИмяСвойства%", ИмяСвойства);
		ТекстСообщения = НСтр("ru='Не удалось записать объект метаданных по причине:
			|%ПодробноеПредставлениеОшибки(ИнформацияОбОшибке)%
			|Категория    = %Владелец%
			|Код          = %Код%
			|Наименование = %Наименование%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПодробноеПредставлениеОшибки(ИнформацияОбОшибке)%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Владелец%", ТекущийОбъект.Владелец);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Код%", ТекущийОбъект.Код);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Наименование%", ТекущийОбъект.Наименование);
		ИнтернетПоддержкаПользователей.ЗаписатьСообщениеВЖурналРегистрации(
			НСтр("ru='БИП:Новости.Сервис и регламент'"), // ИмяСобытия
			ИдентификаторШага, // ИдентификаторШага
			УровеньЖурналаРегистрации.Ошибка, // УровеньЖурналаРегистрации.*
			ОбъектМетаданных, // ОбъектМетаданных
			, // Данные
			ТекстСообщения, // Комментарий
			ОбработкаНовостейВызовСервера.ВестиПодробныйЖурналРегистрации()); // ВестиПодробныйЖурналРегистрации
		СтрокаЛогаЗагрузки = СтрокаЛогаЗагрузки + ". "
			+ СтрШаблон(
				НСтр("ru='Произошла ошибка записи: %1'"),
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
	КонецПопытки;

	ЛогЗагрузки = ЛогЗагрузки + СтрокаЛогаЗагрузки + Символы.ПС;

КонецПроцедуры

// Возвращает реквизиты справочника, которые образуют естественный ключ для элементов справочника.
// Используется для сопоставления элементов механизмом "Выгрузка/загрузка областей данных".
//
// Возвращаемое значение: Массив(Строка) - массив имен реквизитов, образующих естественный ключ.
//
Функция ПоляЕстественногоКлюча() Экспорт

	Результат = Новый Массив;

	Результат.Добавить("Код");

	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецЕсли