﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнтеграцияЕГАИСПереопределяемый.ОбработкаЗаполненияДокумента(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ТаблицаДвижений = ПолучитьТаблицуДвижений();
	
	РегистрыНакопления.ОстаткиАлкогольнойПродукцииЕГАИС.ЗаписатьТаблицуДвижений(ТаблицаДвижений, Движения, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	СтатусОбработки = Перечисления.СтатусыОбработкиОстатковЕГАИС.Новый;
	
	ОстаткиПоДаннымЕГАИС.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗаполнитьПоРасхождениям() Экспорт
	
	КорректировкаОстатков.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Период", Новый Граница(МоментВремени(), ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("ОрганизацияЕГАИС", ОрганизацияЕГАИС);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОстаткиАлкогольнойПродукцииЕГАИСОстатки.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ОстаткиАлкогольнойПродукцииЕГАИСОстатки.СправкаБ КАК СправкаБ,
	|	ОстаткиАлкогольнойПродукцииЕГАИСОстатки.КоличествоОстаток КАК Количество
	|ПОМЕСТИТЬ ОстаткиПоУчету
	|ИЗ
	|	РегистрНакопления.ОстаткиАлкогольнойПродукцииЕГАИС.Остатки(&Период, ОрганизацияЕГАИС = &ОрганизацияЕГАИС) КАК ОстаткиАлкогольнойПродукцииЕГАИСОстатки
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АлкогольнаяПродукция,
	|	СправкаБ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОстаткиЕГАИСОстаткиПоДаннымЕГАИС.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ОстаткиЕГАИСОстаткиПоДаннымЕГАИС.СправкаБ КАК СправкаБ,
	|	ОстаткиЕГАИСОстаткиПоДаннымЕГАИС.Количество КАК Количество
	|ПОМЕСТИТЬ ОстаткиЕГАИС
	|ИЗ
	|	Документ.ОстаткиЕГАИС.ОстаткиПоДаннымЕГАИС КАК ОстаткиЕГАИСОстаткиПоДаннымЕГАИС
	|ГДЕ
	|	ОстаткиЕГАИСОстаткиПоДаннымЕГАИС.Ссылка = &Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АлкогольнаяПродукция,
	|	СправкаБ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОстаткиПоУчету.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ОстаткиПоУчету.СправкаБ,
	|	ЕСТЬNULL(ОстаткиЕГАИС.Количество, 0) - ОстаткиПоУчету.Количество КАК Количество
	|ИЗ
	|	ОстаткиПоУчету КАК ОстаткиПоУчету
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОстаткиЕГАИС КАК ОстаткиЕГАИС
	|		ПО ОстаткиПоУчету.АлкогольнаяПродукция = ОстаткиЕГАИС.АлкогольнаяПродукция
	|			И ОстаткиПоУчету.СправкаБ = ОстаткиЕГАИС.СправкаБ
	|ГДЕ
	|	ЕСТЬNULL(ОстаткиЕГАИС.Количество, 0) - ОстаткиПоУчету.Количество <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОстаткиЕГАИС.АлкогольнаяПродукция,
	|	ОстаткиЕГАИС.СправкаБ,
	|	ОстаткиЕГАИС.Количество
	|ИЗ
	|	ОстаткиЕГАИС КАК ОстаткиЕГАИС
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОстаткиПоУчету КАК ОстаткиПоУчету
	|		ПО ОстаткиЕГАИС.АлкогольнаяПродукция = ОстаткиПоУчету.АлкогольнаяПродукция
	|			И ОстаткиЕГАИС.СправкаБ = ОстаткиПоУчету.СправкаБ
	|ГДЕ
	|	ОстаткиПоУчету.Количество ЕСТЬ NULL 
	|
	|УПОРЯДОЧИТЬ ПО
	|	АлкогольнаяПродукция
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	КорректировкаОстатков.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьТаблицуДвижений()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ОстаткиЕГАИСКорректировкаОстатков.Количество > 0
	|			ТОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|		ИНАЧЕ ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|	КОНЕЦ КАК ВидДвижения,
	|	ОстаткиЕГАИСКорректировкаОстатков.Ссылка.Дата КАК Период,
	|	ОстаткиЕГАИСКорректировкаОстатков.Ссылка КАК Регистратор,
	|	ОстаткиЕГАИСКорректировкаОстатков.НомерСтроки КАК НомерСтроки,
	|	ОстаткиЕГАИСКорректировкаОстатков.Ссылка.ОрганизацияЕГАИС КАК ОрганизацияЕГАИС,
	|	ОстаткиЕГАИСКорректировкаОстатков.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ОстаткиЕГАИСКорректировкаОстатков.СправкаБ КАК СправкаБ,
	|	ОстаткиЕГАИСКорректировкаОстатков.Количество КАК Количество,
	|	ОстаткиЕГАИСКорректировкаОстатков.Количество КАК СвободныйОстаток
	|ИЗ
	|	Документ.ОстаткиЕГАИС.КорректировкаОстатков КАК ОстаткиЕГАИСКорректировкаОстатков
	|ГДЕ
	|	ОстаткиЕГАИСКорректировкаОстатков.Ссылка = &Ссылка
	|	И ОстаткиЕГАИСКорректировкаОстатков.Ссылка.ОрганизацияЕГАИС.УчитыватьОстаткиАлкогольнойПродукции
	|	И ОстаткиЕГАИСКорректировкаОстатков.Ссылка.ВидДокумента = ЗНАЧЕНИЕ(Перечисление.ВидыДокументовЕГАИС.ЗапросОстатков)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

#КонецЕсли