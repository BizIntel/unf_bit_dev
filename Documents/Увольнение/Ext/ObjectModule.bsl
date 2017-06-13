﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ) 
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	УвольнениеСотрудники.НомерСтроки,
	|	УвольнениеСотрудники.Сотрудник,
	|	УвольнениеСотрудники.Период
	|ПОМЕСТИТЬ ТаблицаСотрудники
	|ИЗ
	|	Документ.Увольнение.Сотрудники КАК УвольнениеСотрудники
	|ГДЕ
	|	УвольнениеСотрудники.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаСотрудники.НомерСтроки КАК НомерСтроки,
	|	Сотрудники.Регистратор
	|ИЗ
	|	ТаблицаСотрудники КАК ТаблицаСотрудники
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.Сотрудники КАК Сотрудники
	|		ПО (Сотрудники.Организация = &Организация)
	|			И ТаблицаСотрудники.Сотрудник = Сотрудники.Сотрудник
	|			И ТаблицаСотрудники.Период = Сотрудники.Период
	|			И (Сотрудники.Регистратор <> &Ссылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ТаблицаСотрудникиДублиСтрок.НомерСтроки) КАК НомерСтроки,
	|	ТаблицаСотрудникиДублиСтрок.Сотрудник
	|ИЗ
	|	ТаблицаСотрудники КАК ТаблицаСотрудники
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаСотрудники КАК ТаблицаСотрудникиДублиСтрок
	|		ПО ТаблицаСотрудники.НомерСтроки <> ТаблицаСотрудникиДублиСтрок.НомерСтроки
	|			И ТаблицаСотрудники.Сотрудник = ТаблицаСотрудникиДублиСтрок.Сотрудник
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаСотрудникиДублиСтрок.Сотрудник
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки");
	
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Организация", УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(Организация));
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	// Регистр "Сотрудники".
	Если НЕ МассивРезультатов[1].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[1].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = НСтр(
				"ru = 'В строке №%Номер% табл. части ""Сотрудники"" период действия приказа противоречит кадровому приказу ""%КадровыйПриказ%"".'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Номер%", ВыборкаИзРезультатаЗапроса.НомерСтроки); 
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КадровыйПриказ%", ВыборкаИзРезультатаЗапроса.Регистратор);
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"Сотрудники",
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				"Период",
				Отказ);
		КонецЦикла;
	КонецЕсли;
	
	// Дубли строк.
	Если НЕ МассивРезультатов[2].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[2].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = НСтр(
				"ru = 'В строке №%Номер% табл. части ""Сотрудники"" сотрудник указывается повторно.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Номер%", ВыборкаИзРезультатаЗапроса.НомерСтроки);
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"Сотрудники",
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				"Сотрудник",
				Отказ);
		КонецЦикла;
	КонецЕсли;	
		
КонецПроцедуры

// Выполняет контроль противоречий.
//
Процедура ВыполнитьКонтроль(ДополнительныеСвойства, Отказ) 
	
	Если Отказ Тогда
		Возврат;	
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВложенныйЗапрос.Сотрудник,
	|	ВложенныйЗапрос.НомерСтроки КАК НомерСтроки,
	|	Сотрудники.СтруктурнаяЕдиница
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаСотрудники.Сотрудник КАК Сотрудник,
	|		ТаблицаСотрудники.НомерСтроки КАК НомерСтроки,
	|		МАКСИМУМ(Сотрудники.Период) КАК Период
	|	ИЗ
	|		ТаблицаСотрудники КАК ТаблицаСотрудники
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Сотрудники КАК Сотрудники
	|			ПО (Сотрудники.Сотрудник = ТаблицаСотрудники.Сотрудник)
	|				И (Сотрудники.Организация = &Организация)
	|				И (Сотрудники.Период <= ТаблицаСотрудники.Период)
	|				И (Сотрудники.Регистратор <> &Ссылка)
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ТаблицаСотрудники.Сотрудник,
	|		ТаблицаСотрудники.НомерСтроки) КАК ВложенныйЗапрос
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Сотрудники КАК Сотрудники
	|		ПО ВложенныйЗапрос.Сотрудник = Сотрудники.Сотрудник
	|			И ВложенныйЗапрос.Период = Сотрудники.Период
	|			И (Сотрудники.Организация = &Организация)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаСотрудники.НомерСтроки КАК НомерСтроки,
	|	ТаблицаСотрудники.Сотрудник,
	|	МИНИМУМ(Сотрудники.Период) КАК Период
	|ИЗ
	|	ТаблицаСотрудники КАК ТаблицаСотрудники
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.Сотрудники КАК Сотрудники
	|		ПО (Сотрудники.Сотрудник = ТаблицаСотрудники.Сотрудник)
	|			И (Сотрудники.Период > ТаблицаСотрудники.Период)
	|			И (Сотрудники.Регистратор <> &Ссылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаСотрудники.Сотрудник,
	|	ТаблицаСотрудники.НомерСтроки
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки");
	
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Организация", ДополнительныеСвойства.ДляПроведения.Организация);
	
	Результат = Запрос.ВыполнитьПакет();
	
	// Сотрудник не принят в организацию на дату увольнения.
	ВыборкаИзРезультатаЗапроса = Результат[0].Выбрать();
	Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
		Если Не ЗначениеЗаполнено(ВыборкаИзРезультатаЗапроса.СтруктурнаяЕдиница) Тогда
		    ТекстСообщения = НСтр(
				"ru = 'В строке №%Номер% табл. части ""Сотрудники"" сотрудник %Сотрудник% не принят на работу в организацию %Организация%.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Номер%", ВыборкаИзРезультатаЗапроса.НомерСтроки); 
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Сотрудник%", ВыборкаИзРезультатаЗапроса.Сотрудник); 
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Организация%", ДополнительныеСвойства.ДляПроведения.Организация);
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"Сотрудники",
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				"Сотрудник",
				Отказ);
		КонецЕсли; 
	КонецЦикла;
	
	// По сотруднику есть движения после увольнения.
	ВыборкаИзРезультатаЗапроса = Результат[1].Выбрать();
	Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
		ТекстСообщения = НСтр(
			"ru = 'В строке №%Номер% табл. части ""Сотрудники"" по сотруднику %Сотрудник% есть кадровые движения %Период% после даты увольнения.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Номер%", ВыборкаИзРезультатаЗапроса.НомерСтроки); 
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Сотрудник%", ВыборкаИзРезультатаЗапроса.Сотрудник); 
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Период%", Формат(ВыборкаИзРезультатаЗапроса.Период, "ДФ=dd.MM.yy"));
		УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
			ЭтотОбъект,
			ТекстСообщения,
			"Сотрудники",
			ВыборкаИзРезультатаЗапроса.НомерСтроки,
			"Сотрудник",
			Отказ);
	КонецЦикла; 
			
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.Увольнение.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	УправлениеНебольшойФирмойСервер.ОтразитьСотрудники(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьПлановыеНачисленияИУдержания(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей.
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Отражение текущих кадровых данных
	РегистрыСведений.ТекущиеКадровыеДанныеСотрудников.ОбновитьТекущиеКадровыеДанныеСотрудников();
	
	// Контроль
	ВыполнитьКонтроль(ДополнительныеСвойства, Отказ);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры // ОбработкаПроведения()

// В обработчике события ОбработкаПроверкиЗаполнения документа выполняется
// копирование и обнуление проверяемых реквизитов для исключения стандартной
// проверки заполнения платформой и последующей проверки средствами встроенного языка.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	// Предварительный контроль
	ВыполнитьПредварительныйКонтроль(Отказ);	
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для удаления проведения документа
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Отражение текущих кадровых данных
	РегистрыСведений.ТекущиеКадровыеДанныеСотрудников.ОбновитьТекущиеКадровыеДанныеСотрудников();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли