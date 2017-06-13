﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоВнеоборотнымАктивам(ДанныеЗаполнения) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПараметрыАмортизацииСрезПоследних.Регистратор.Организация КАК Организация
	|ИЗ
	|	РегистрСведений.ПараметрыВнеоборотныхАктивов.СрезПоследних(, ВнеоборотныйАктив = &ВнеоборотныйАктив) КАК ПараметрыАмортизацииСрезПоследних");
	
	Запрос.УстановитьПараметр("ВнеоборотныйАктив", ДанныеЗаполнения);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Организация = Выборка.Организация;
	КонецЕсли;
	
	НоваяСтрока = ВнеоборотныеАктивы.Добавить();
	НоваяСтрока.ВнеоборотныйАктив = ДанныеЗаполнения;
	
КонецПроцедуры // ЗаполнитьПоВнеоборотнымАктивам()

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("СправочникСсылка.ВнеоборотныеАктивы")] = "ЗаполнитьПоВнеоборотнымАктивам";
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
КонецПроцедуры // ОбработкаЗаполнения()

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Выполнение предварительного контроля.
	ВыполнитьПредварительныйКонтроль(Отказ);
	
	Для каждого СтрокаВнеоборотныхАктивов Из ВнеоборотныеАктивы Цикл
			
		Если СтрокаВнеоборотныхАктивов.ВнеоборотныйАктив.СпособАмортизации <> Перечисления.СпособыНачисленияАмортизацииВнеоборотныхАктивов.ПропорциональноОбъемуПродукции Тогда
			ТекстСообщения = НСтр("ru = 'Для имущества %ВнеоборотныйАктив% указанного в строке %НомерСтроки% списка ""Имущество"", используется способ начисления амортизации отличный от ""Пропорционально объему продукции (работ)"".'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ВнеоборотныйАктив%", СокрЛП(Строка(СтрокаВнеоборотныхАктивов.ВнеоборотныйАктив)));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НомерСтроки%", Строка(СтрокаВнеоборотныхАктивов.НомерСтроки));
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"ВнеоборотныеАктивы",
				СтрокаВнеоборотныхАктивов.НомерСтроки,
				"ВнеоборотныйАктив",
				Отказ
			);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа
	Документы.ВыработкаВА.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета
	УправлениеНебольшойФирмойСервер.ОтразитьВыработкаВнеоборотныхАктивов(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры // ОбработкаПроведения()

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для удаления проведения документа
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
КонецПроцедуры // ОбработкаУдаленияПроведения()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет предварительный контроль.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(Организация));
	Запрос.УстановитьПараметр("Период", Дата);
	Запрос.УстановитьПараметр("СписокВнеоборотныхАктивов", ВнеоборотныеАктивы.ВыгрузитьКолонку("ВнеоборотныйАктив"));
	
	// Проверка состояний имущества.
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СостояниеВнеоборотногоАктиваСрезПоследних.ВнеоборотныйАктив КАК ВнеоборотныйАктив
	|ИЗ
	|	РегистрСведений.СостоянияВнеоборотныхАктивов.СрезПоследних(&Период, Организация = &Организация) КАК СостояниеВнеоборотногоАктиваСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СостояниеВнеоборотногоАктиваСрезПоследних.ВнеоборотныйАктив КАК ВнеоборотныйАктив
	|ИЗ
	|	РегистрСведений.СостоянияВнеоборотныхАктивов.СрезПоследних(
	|			&Период,
	|			Организация = &Организация
	|				И ВнеоборотныйАктив В (&СписокВнеоборотныхАктивов)
	|				И Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияВнеоборотныхАктивов.ПринятКУчету)) КАК СостояниеВнеоборотногоАктиваСрезПоследних";
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	МассивВАСостояния = МассивРезультатов[0].Выгрузить().ВыгрузитьКолонку("ВнеоборотныйАктив");
	МассивВАПринятКУчету = МассивРезультатов[1].Выгрузить().ВыгрузитьКолонку("ВнеоборотныйАктив");
	
	Для каждого СтрокаВнеоборотныхАктивов Из ВнеоборотныеАктивы Цикл
			
		Если МассивВАСостояния.Найти(СтрокаВнеоборотныхАктивов.ВнеоборотныйАктив) = Неопределено Тогда
			ТекстСообщения = НСтр("ru = 'Для имущества %ВнеоборотныйАктив% указанного в строке %НомерСтроки% списка ""Имущество"", не зарегистрированы состояния.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ВнеоборотныйАктив%", СокрЛП(Строка(СтрокаВнеоборотныхАктивов.ВнеоборотныйАктив)));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НомерСтроки%", Строка(СтрокаВнеоборотныхАктивов.НомерСтроки));
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"ВнеоборотныеАктивы",
				СтрокаВнеоборотныхАктивов.НомерСтроки,
				"ВнеоборотныйАктив",
				Отказ
			);
		ИначеЕсли МассивВАПринятКУчету.Найти(СтрокаВнеоборотныхАктивов.ВнеоборотныйАктив) = Неопределено Тогда
			ТекстСообщения = НСтр("ru = 'Для имущества %ВнеоборотныйАктив% указанного в строке %НомерСтроки% списка ""Имущество"", текущее состояние ""Снят с учета"".'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ВнеоборотныйАктив%", СокрЛП(Строка(СтрокаВнеоборотныхАктивов.ВнеоборотныйАктив)));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НомерСтроки%", Строка(СтрокаВнеоборотныхАктивов.НомерСтроки));
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"ВнеоборотныеАктивы",
				СтрокаВнеоборотныхАктивов.НомерСтроки,
				"ВнеоборотныйАктив",
				Отказ
			);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ВыполнитьПредварительныйКонтроль()

#КонецОбласти

#КонецЕсли