﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыЗаполненияДокумента

// Процедура заполняет авансы.
//
Процедура ЗаполнитьПредоплату(ОстаткиПолучатьНаДатуДокумента = Ложь) Экспорт
	
	ЗаказВШапке = (ПоложениеЗаказаПокупателя = Перечисления.ПоложениеРеквизитаНаФорме.ВШапке);
	Компания = УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(Организация);
	
	ТаблицаЗаказов = РаботыИУслуги.Выгрузить(, "ЗаказПокупателя, Всего");
	ТаблицаЗаказов.Колонки.Добавить("ВсегоРасч");
	Для каждого ТекСтрока Из ТаблицаЗаказов Цикл
		Если НЕ Контрагент.ВестиРасчетыПоЗаказам Тогда
			ТекСтрока.ЗаказПокупателя = Документы.ЗаказПокупателя.ПустаяСсылка();
		ИначеЕсли ЗаказВШапке Тогда
			ТекСтрока.ЗаказПокупателя = ЗаказПокупателя;
		КонецЕсли;
		ТекСтрока.ВсегоРасч = УправлениеНебольшойФирмойСервер.ПересчитатьИзВалютыВВалюту(
			ТекСтрока.Всего,
			?(Договор.ВалютаРасчетов = ВалютаДокумента, Курс, 1),
			Курс,
			?(Договор.ВалютаРасчетов = ВалютаДокумента, Кратность, 1),
			Кратность
		);
	КонецЦикла;
	ТаблицаЗаказов.Свернуть("ЗаказПокупателя", "Всего, ВсегоРасч");
	ТаблицаЗаказов.Сортировать("ЗаказПокупателя Возр");
	
	// Заполнение расшифровки предоплаты.
	Запрос = Новый Запрос;
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РасчетыСПокупателямиОстатки.Документ КАК Документ,
	|	РасчетыСПокупателямиОстатки.Заказ КАК Заказ,
	|	РасчетыСПокупателямиОстатки.ДокументДата КАК ДокументДата,
	|	РасчетыСПокупателямиОстатки.Договор.ВалютаРасчетов КАК ВалютаРасчетов,
	|	СУММА(РасчетыСПокупателямиОстатки.СуммаОстаток) КАК СуммаОстаток,
	|	СУММА(РасчетыСПокупателямиОстатки.СуммаВалОстаток) КАК СуммаВалОстаток,
	|	СУММА(РасчетыСПокупателямиОстатки.СуммаРегОстаток) КАК СуммаРегОстаток
	|ПОМЕСТИТЬ ВременнаяТаблицаРасчетыСПокупателямиОстатки
	|ИЗ
	|	(ВЫБРАТЬ
	|		РасчетыСПокупателямиОстатки.Договор КАК Договор,
	|		РасчетыСПокупателямиОстатки.Документ КАК Документ,
	|		РасчетыСПокупателямиОстатки.Документ.Дата КАК ДокументДата,
	|		РасчетыСПокупателямиОстатки.Заказ КАК Заказ,
	|		ЕСТЬNULL(РасчетыСПокупателямиОстатки.СуммаОстаток, 0) КАК СуммаОстаток,
	|		ЕСТЬNULL(РасчетыСПокупателямиОстатки.СуммаВалОстаток, 0) КАК СуммаВалОстаток,
	|		ЕСТЬNULL(РасчетыСПокупателямиОстатки.СуммаРегОстаток, 0) КАК СуммаРегОстаток
	|	ИЗ
	|		РегистрНакопления.РасчетыСПокупателями.Остатки(
	|				&ПериодОстатков,
	|				Организация = &Организация
	|					И Контрагент = &Контрагент
	|					И Договор = &Договор
	|					И Заказ В (&Заказ)
	|					И ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Аванс)) КАК РасчетыСПокупателямиОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияДокументаРасчетыСПокупателями.Договор,
	|		ДвиженияДокументаРасчетыСПокупателями.Документ,
	|		ДвиженияДокументаРасчетыСПокупателями.Документ.Дата,
	|		ДвиженияДокументаРасчетыСПокупателями.Заказ,
	|		ВЫБОР
	|			КОГДА ДвиженияДокументаРасчетыСПокупателями.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ЕСТЬNULL(ДвиженияДокументаРасчетыСПокупателями.Сумма, 0)
	|			ИНАЧЕ ЕСТЬNULL(ДвиженияДокументаРасчетыСПокупателями.Сумма, 0)
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА ДвиженияДокументаРасчетыСПокупателями.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ЕСТЬNULL(ДвиженияДокументаРасчетыСПокупателями.СуммаВал, 0)
	|			ИНАЧЕ ЕСТЬNULL(ДвиженияДокументаРасчетыСПокупателями.СуммаВал, 0)
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА ДвиженияДокументаРасчетыСПокупателями.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ЕСТЬNULL(ДвиженияДокументаРасчетыСПокупателями.СуммаРег, 0)
	|			ИНАЧЕ ЕСТЬNULL(ДвиженияДокументаРасчетыСПокупателями.СуммаРег, 0)
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.РасчетыСПокупателями КАК ДвиженияДокументаРасчетыСПокупателями
	|	ГДЕ
	|		ДвиженияДокументаРасчетыСПокупателями.Регистратор = &Ссылка
	|		И ДвиженияДокументаРасчетыСПокупателями.Период <= &Период
	|		И ДвиженияДокументаРасчетыСПокупателями.Организация = &Организация
	|		И ДвиженияДокументаРасчетыСПокупателями.Контрагент = &Контрагент
	|		И ДвиженияДокументаРасчетыСПокупателями.Договор = &Договор
	|		И ДвиженияДокументаРасчетыСПокупателями.Заказ В(&Заказ)
	|		И ДвиженияДокументаРасчетыСПокупателями.ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Аванс)) КАК РасчетыСПокупателямиОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыСПокупателямиОстатки.Документ,
	|	РасчетыСПокупателямиОстатки.Заказ,
	|	РасчетыСПокупателямиОстатки.ДокументДата,
	|	РасчетыСПокупателямиОстатки.Договор.ВалютаРасчетов
	|
	|ИМЕЮЩИЕ
	|	СУММА(РасчетыСПокупателямиОстатки.СуммаВалОстаток) < 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РасчетыСПокупателямиОстатки.Документ КАК Документ,
	|	РасчетыСПокупателямиОстатки.Заказ КАК Заказ,
	|	РасчетыСПокупателямиОстатки.ДокументДата КАК ДокументДата,
	|	РасчетыСПокупателямиОстатки.ВалютаРасчетов КАК ВалютаРасчетов,
	|	-СУММА(РасчетыСПокупателямиОстатки.СуммаУчета) КАК СуммаУчета,
	|	-СУММА(РасчетыСПокупателямиОстатки.СуммаРасчетов) КАК СуммаРасчетов,
	|	-СУММА(РасчетыСПокупателямиОстатки.СуммаПлатежа) КАК СуммаПлатежа,
	|	СУММА(ВЫБОР
	|			КОГДА ЕСТЬNULL(РасчетыСПокупателямиОстатки.СуммаРег, 0) = 0
	|				ТОГДА РасчетыСПокупателямиОстатки.СуммаУчета / ВЫБОР
	|						КОГДА ЕСТЬNULL(РасчетыСПокупателямиОстатки.СуммаРасчетов, 0) <> 0
	|							ТОГДА РасчетыСПокупателямиОстатки.СуммаРасчетов
	|						ИНАЧЕ 1
	|					КОНЕЦ * (РасчетыСПокупателямиОстатки.КурсыВалютыУчетаКурс / РасчетыСПокупателямиОстатки.КурсыВалютыУчетаКратность)
	|			ИНАЧЕ РасчетыСПокупателямиОстатки.СуммаРег / ВЫБОР
	|					КОГДА ЕСТЬNULL(РасчетыСПокупателямиОстатки.СуммаРасчетов, 0) <> 0
	|						ТОГДА РасчетыСПокупателямиОстатки.СуммаРасчетов
	|					ИНАЧЕ 1
	|				КОНЕЦ
	|		КОНЕЦ) КАК Курс,
	|	1 КАК Кратность,
	|	РасчетыСПокупателямиОстатки.КурсыВалютыДокументаКурс КАК КурсыВалютыДокументаКурс,
	|	РасчетыСПокупателямиОстатки.КурсыВалютыДокументаКратность КАК КурсыВалютыДокументаКратность
	|ИЗ
	|	(ВЫБРАТЬ
	|		РасчетыСПокупателямиОстатки.ВалютаРасчетов КАК ВалютаРасчетов,
	|		РасчетыСПокупателямиОстатки.Документ КАК Документ,
	|		РасчетыСПокупателямиОстатки.ДокументДата КАК ДокументДата,
	|		РасчетыСПокупателямиОстатки.Заказ КАК Заказ,
	|		ЕСТЬNULL(РасчетыСПокупателямиОстатки.СуммаОстаток, 0) КАК СуммаУчета,
	|		ЕСТЬNULL(РасчетыСПокупателямиОстатки.СуммаВалОстаток, 0) КАК СуммаРасчетов,
	|		ЕСТЬNULL(РасчетыСПокупателямиОстатки.СуммаОстаток, 0) * КурсыВалютыУчета.Курс * &КратностьВалютыДокумента / (&КурсВалютыДокумента * КурсыВалютыУчета.Кратность) КАК СуммаПлатежа,
	|		КурсыВалютыУчета.Курс КАК КурсыВалютыУчетаКурс,
	|		КурсыВалютыУчета.Кратность КАК КурсыВалютыУчетаКратность,
	|		&КурсВалютыДокумента КАК КурсыВалютыДокументаКурс,
	|		&КратностьВалютыДокумента КАК КурсыВалютыДокументаКратность,
	|		ЕСТЬNULL(РасчетыСПокупателямиОстатки.СуммаРегОстаток, 0) КАК СуммаРег
	|	ИЗ
	|		ВременнаяТаблицаРасчетыСПокупателямиОстатки КАК РасчетыСПокупателямиОстатки
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&Период, Валюта = &ВалютаУчета) КАК КурсыВалютыУчета
	|			ПО (ИСТИНА)) КАК РасчетыСПокупателямиОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыСПокупателямиОстатки.Документ,
	|	РасчетыСПокупателямиОстатки.Заказ,
	|	РасчетыСПокупателямиОстатки.ДокументДата,
	|	РасчетыСПокупателямиОстатки.ВалютаРасчетов,
	|	РасчетыСПокупателямиОстатки.КурсыВалютыУчетаКурс,
	|	РасчетыСПокупателямиОстатки.КурсыВалютыУчетаКратность,
	|	РасчетыСПокупателямиОстатки.КурсыВалютыДокументаКурс,
	|	РасчетыСПокупателямиОстатки.КурсыВалютыДокументаКратность
	|
	|ИМЕЮЩИЕ
	|	-СУММА(РасчетыСПокупателямиОстатки.СуммаРасчетов) > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДокументДата";
	
	Запрос.УстановитьПараметр("Заказ", ТаблицаЗаказов.ВыгрузитьКолонку("ЗаказПокупателя"));
	Запрос.УстановитьПараметр("Организация", Компания);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Договор", Договор);
	Запрос.УстановитьПараметр("Период", Дата);
	Запрос.УстановитьПараметр("ВалютаДокумента", ВалютаДокумента);
	Запрос.УстановитьПараметр("ВалютаУчета", Константы.ВалютаУчета.Получить());
	Если Договор.ВалютаРасчетов = ВалютаДокумента Тогда
		Запрос.УстановитьПараметр("КурсВалютыДокумента", Курс);
		Запрос.УстановитьПараметр("КратностьВалютыДокумента", Кратность);
	Иначе
		Запрос.УстановитьПараметр("КурсВалютыДокумента", 1);
		Запрос.УстановитьПараметр("КратностьВалютыДокумента", 1);
	КонецЕсли;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ПериодОстатков", ?(ОстаткиПолучатьНаДатуДокумента, Новый Граница(КонецДня(Дата), ВидГраницы.Включая), Неопределено));
	
	Запрос.Текст = ТекстЗапроса;
	
	Предоплата.Очистить();
	
	ВыборкаРезультатаЗапроса = Запрос.Выполнить().Выбрать();
	
	Пока ВыборкаРезультатаЗапроса.Следующий() Цикл
		
		НайденнаяСтрока = ТаблицаЗаказов.Найти(ВыборкаРезультатаЗапроса.Заказ, "ЗаказПокупателя");
		
		Если НайденнаяСтрока.ВсегоРасч = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Если ВыборкаРезультатаЗапроса.СуммаРасчетов <= НайденнаяСтрока.ВсегоРасч Тогда // сумма остатка меньше или равна чем осталось распределить
			
			НоваяСтрока = Предоплата.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаРезультатаЗапроса);
			НайденнаяСтрока.ВсегоРасч = НайденнаяСтрока.ВсегоРасч - ВыборкаРезультатаЗапроса.СуммаРасчетов;
			
		Иначе // сумма остатка больше чем нужно распределить
			
			НоваяСтрока = Предоплата.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаРезультатаЗапроса);
			НоваяСтрока.СуммаРасчетов = НайденнаяСтрока.ВсегоРасч;
			НоваяСтрока.СуммаПлатежа = УправлениеНебольшойФирмойСервер.ПересчитатьИзВалютыВВалюту(
				НоваяСтрока.СуммаРасчетов,
				ВыборкаРезультатаЗапроса.Курс,
				ВыборкаРезультатаЗапроса.КурсыВалютыДокументаКурс,
				ВыборкаРезультатаЗапроса.Кратность,
				ВыборкаРезультатаЗапроса.КурсыВалютыДокументаКратность
			);
			НайденнаяСтрока.ВсегоРасч = 0;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик заполнения на основании документа ЗаказПокупателя.
//
// Параметры:
//	ДокументСсылкаЗаказПокупателя - ДокументСсылка.ЗаказПокупателя - заказ покупателя.
//	
Процедура ЗаполнитьПоЗаказуПокупателя(ДокументСсылкаЗаказПокупателя) Экспорт
	
	// Основание и настройка документа.
	МассивЗаказов = Новый Массив;
	Если ТипЗнч(ДокументСсылкаЗаказПокупателя) = Тип("Структура") И ДокументСсылкаЗаказПокупателя.Свойство("МассивЗаказовПокупателей") Тогда
		МассивЗаказов = ДокументСсылкаЗаказПокупателя.МассивЗаказовПокупателей;
		ПоложениеЗаказаПокупателя = Перечисления.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти;
	Иначе
		МассивЗаказов.Добавить(ДокументСсылкаЗаказПокупателя);
		ПоложениеЗаказаПокупателя = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеНастройки("ПоложениеЗаказаПокупателяВДокументахОтгрузки");
		Если НЕ ЗначениеЗаполнено(ПоложениеЗаказаПокупателя) Тогда
			ПоложениеЗаказаПокупателя = Перечисления.ПоложениеРеквизитаНаФорме.ВШапке;
		КонецЕсли;
		Если ПоложениеЗаказаПокупателя = Перечисления.ПоложениеРеквизитаНаФорме.ВШапке Тогда
			ЗаказПокупателя = ДокументСсылкаЗаказПокупателя;
		КонецЕсли;
	КонецЕсли;
	
	// Заполнение шапки.
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЗаказПокупателя.Ссылка КАК ОснованиеСсылка,
	|	ЗаказПокупателя.Проведен КАК ОснованиеПроведен,
	|	ЗаказПокупателя.СостояниеЗаказа КАК СостояниеЗаказа,
	|	ЗаказПокупателя.Организация КАК Организация,
	|	ЗаказПокупателя.Контрагент КАК Контрагент,
	|	ЗаказПокупателя.Договор КАК Договор,
	|	ЗаказПокупателя.ВидОперации КАК ВидОперации,
	|	ЗаказПокупателя.ВидЦен КАК ВидЦен,
	|	ЗаказПокупателя.ВидСкидкиНаценки КАК ВидСкидкиНаценки,
	|	ЗаказПокупателя.ДисконтнаяКарта КАК ДисконтнаяКарта,
	|	ЗаказПокупателя.ПроцентСкидкиПоДисконтнойКарте КАК ПроцентСкидкиПоДисконтнойКарте,
	|	ЗаказПокупателя.ВалютаДокумента КАК ВалютаДокумента,
	|	ЗаказПокупателя.НалогообложениеНДС КАК НалогообложениеНДС,
	|	ЗаказПокупателя.СуммаВключаетНДС КАК СуммаВключаетНДС,
	|	ЗаказПокупателя.НДСВключатьВСтоимость КАК НДСВключатьВСтоимость,
	|	ВЫБОР
	|		КОГДА ЗаказПокупателя.ВалютаДокумента = НациональнаяВалюта.Значение
	|			ТОГДА ЗаказПокупателя.Курс
	|		ИНАЧЕ КурсыВалютСрезПоследних.Курс
	|	КОНЕЦ КАК Курс,
	|	ВЫБОР
	|		КОГДА ЗаказПокупателя.ВалютаДокумента = НациональнаяВалюта.Значение
	|			ТОГДА ЗаказПокупателя.Кратность
	|		ИНАЧЕ КурсыВалютСрезПоследних.Кратность
	|	КОНЕЦ КАК Кратность
	|ИЗ
	|	Документ.ЗаказПокупателя КАК ЗаказПокупателя
	|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&ДатаДокумента, ) КАК КурсыВалютСрезПоследних
	|		ПО ЗаказПокупателя.Ссылка.Договор.ВалютаРасчетов = КурсыВалютСрезПоследних.Валюта},
	|	Константа.НациональнаяВалюта КАК НациональнаяВалюта
	|ГДЕ
	|	ЗаказПокупателя.Ссылка В(&МассивЗаказов)");
	
	Запрос.УстановитьПараметр("МассивЗаказов", МассивЗаказов);
	Запрос.УстановитьПараметр("ДатаДокумента", ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДата()));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ВидОперации = Перечисления.ВидыОперацийЗаказПокупателя.ЗаказНаряд Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Нельзя ввести Акт выполненных работ на основании заказ-наряда %1!'"),
			Выборка.ОснованиеСсылка);
		КонецЕсли;
		
		ЗначенияПроверяемыхРеквизитов = Новый Структура("СостояниеЗаказа, Проведен", Выборка.СостояниеЗаказа, Выборка.ОснованиеПроведен);
		Документы.ЗаказПокупателя.ПроверитьВозможностьВводаНаОснованииЗаказаПокупателя(Выборка.ОснованиеСсылка, ЗначенияПроверяемыхРеквизитов);
		
	КонецЦикла;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	
	// Заполнение табличной части.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаказыОстатки.ЗаказПокупателя КАК ЗаказПокупателя,
	|	ЗаказыОстатки.Номенклатура КАК Номенклатура,
	|	ЗаказыОстатки.Характеристика КАК Характеристика,
	|	СУММА(ЗаказыОстатки.КоличествоОстаток) КАК КоличествоОстаток
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗаказыОстатки.ЗаказПокупателя КАК ЗаказПокупателя,
	|		ЗаказыОстатки.Номенклатура КАК Номенклатура,
	|		ЗаказыОстатки.Характеристика КАК Характеристика,
	|		ЗаказыОстатки.КоличествоОстаток КАК КоличествоОстаток
	|	ИЗ
	|		РегистрНакопления.ЗаказыПокупателей.Остатки(
	|				,
	|				ЗаказПокупателя В (&МассивЗаказов)
	|					И (Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа)
	|						ИЛИ Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга))) КАК ЗаказыОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияДокументаЗаказыПокупателей.ЗаказПокупателя,
	|		ДвиженияДокументаЗаказыПокупателей.Номенклатура,
	|		ДвиженияДокументаЗаказыПокупателей.Характеристика,
	|		ВЫБОР
	|			КОГДА ДвиженияДокументаЗаказыПокупателей.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|				ТОГДА ЕСТЬNULL(ДвиженияДокументаЗаказыПокупателей.Количество, 0)
	|			ИНАЧЕ -ЕСТЬNULL(ДвиженияДокументаЗаказыПокупателей.Количество, 0)
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.ЗаказыПокупателей КАК ДвиженияДокументаЗаказыПокупателей
	|	ГДЕ
	|		ДвиженияДокументаЗаказыПокупателей.Регистратор = &Ссылка) КАК ЗаказыОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаказыОстатки.ЗаказПокупателя,
	|	ЗаказыОстатки.Номенклатура,
	|	ЗаказыОстатки.Характеристика
	|
	|ИМЕЮЩИЕ
	|	СУММА(ЗаказыОстатки.КоличествоОстаток) > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаказПокупателяЗапасы.НомерСтроки КАК НомерСтроки,
	|	ЗаказПокупателяЗапасы.Номенклатура КАК Номенклатура,
	|	ЗаказПокупателяЗапасы.Характеристика КАК Характеристика,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ЗаказПокупателяЗапасы.ЕдиницаИзмерения) = ТИП(Справочник.КлассификаторЕдиницИзмерения)
	|			ТОГДА 1
	|		ИНАЧЕ ЗаказПокупателяЗапасы.ЕдиницаИзмерения.Коэффициент
	|	КОНЕЦ КАК Коэффициент,
	|	ЗаказПокупателяЗапасы.Количество КАК Количество,
	|	ЗаказПокупателяЗапасы.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ЗаказПокупателяЗапасы.Цена КАК Цена,
	|	ЗаказПокупателяЗапасы.ПроцентСкидкиНаценки КАК ПроцентСкидкиНаценки,
	|	ЗаказПокупателяЗапасы.Сумма КАК Сумма,
	|	ЗаказПокупателяЗапасы.СтавкаНДС КАК СтавкаНДС,
	|	ЗаказПокупателяЗапасы.СуммаНДС КАК СуммаНДС,
	|	ЗаказПокупателяЗапасы.Всего КАК Всего,
	|	ЗаказПокупателяЗапасы.Ссылка КАК ЗаказПокупателя,
	|	ЗаказПокупателяЗапасы.Содержание КАК Содержание,
	|	ЗаказПокупателяЗапасы.ПроцентАвтоматическойСкидки,
	|	ЗаказПокупателяЗапасы.СуммаАвтоматическойСкидки,
	|	ЗаказПокупателяЗапасы.КлючСвязи
	|ИЗ
	|	Документ.ЗаказПокупателя.Запасы КАК ЗаказПокупателяЗапасы
	|ГДЕ
	|	ЗаказПокупателяЗапасы.Ссылка В(&МассивЗаказов)
	|	И (ЗаказПокупателяЗапасы.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа)
	|			ИЛИ ЗаказПокупателяЗапасы.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга))
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СкидкиНаценки.Ссылка КАК Заказ,
	|	СкидкиНаценки.КлючСвязи КАК КлючСвязи,
	|	СкидкиНаценки.СкидкаНаценка КАК СкидкаНаценка,
	|	СкидкиНаценки.Сумма КАК Сумма
	|ИЗ
	|	Документ.ЗаказПокупателя.СкидкиНаценки КАК СкидкиНаценки
	|ГДЕ
	|	СкидкиНаценки.Ссылка В(&МассивЗаказов)";
	
	Запрос.УстановитьПараметр("МассивЗаказов", МассивЗаказов);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	ТаблицаОстатков = МассивРезультатов[0].Выгрузить();
	ТаблицаОстатков.Индексы.Добавить("ЗаказПокупателя, Номенклатура,Характеристика");
	
	// АвтоматическиеСкидки.
	ИспользоватьАвтоматическиеСкидки = ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическиеСкидкиНаценки");
	Если ИспользоватьАвтоматическиеСкидки Тогда
		СкидкиНаценкиЗаказа = МассивРезультатов[2].Выгрузить();
		СкидкиНаценки.Очистить();
	КонецЕсли;
	// Конец АвтоматическиеСкидки.
	
	РаботыИУслуги.Очистить();
	Если ТаблицаОстатков.Количество() > 0 Тогда
		
		Выборка = МассивРезультатов[1].Выбрать();
		Пока Выборка.Следующий() Цикл
			
			СтруктураДляПоиска = Новый Структура;
			СтруктураДляПоиска.Вставить("ЗаказПокупателя", Выборка.ЗаказПокупателя);
			СтруктураДляПоиска.Вставить("Номенклатура", Выборка.Номенклатура);
			СтруктураДляПоиска.Вставить("Характеристика", Выборка.Характеристика);
			
			МассивСтрокОстатков = ТаблицаОстатков.НайтиСтроки(СтруктураДляПоиска);
			Если МассивСтрокОстатков.Количество() = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = РаботыИУслуги.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			
			КоличествоКСписанию = Выборка.Количество * Выборка.Коэффициент;
			МассивСтрокОстатков[0].КоличествоОстаток = МассивСтрокОстатков[0].КоличествоОстаток - КоличествоКСписанию;
			Если МассивСтрокОстатков[0].КоличествоОстаток < 0 Тогда
				
				КоличествоКСписанию = (КоличествоКСписанию + МассивСтрокОстатков[0].КоличествоОстаток) / Выборка.Коэффициент;
				
				СтруктураДанных = УправлениеНебольшойФирмойСервер.ПолучитьСуммуСтрокиТабличнойЧасти(
					Новый Структура("Количество, Цена, Сумма, ПроцентСкидкиНаценки, СтавкаНДС, СуммаНДС, СуммаВключаетНДС, Всего",
						КоличествоКСписанию, Выборка.Цена, 0, Выборка.ПроцентСкидкиНаценки, Выборка.СтавкаНДС, 0, СуммаВключаетНДС, 0));
				
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураДанных);
				
			КонецЕсли;
			
			// АвтоматическиеСкидки
			Если ИспользоватьАвтоматическиеСкидки Тогда
				КоличествоВДокументе = Выборка.Количество * Выборка.Коэффициент;
				ПересчитатьСуммы = КоличествоВДокументе <> КоличествоКСписанию;
				КоэффициентПересчетаСкидки = ?(ПересчитатьСуммы, КоличествоКСписанию / КоличествоВДокументе, 1);
				Если КоэффициентПересчетаСкидки <> 1 Тогда
					НоваяСтрока.СуммаАвтоматическойСкидки = ОКР(Выборка.СуммаАвтоматическойСкидки * КоэффициентПересчетаСкидки,2);
				КонецЕсли;
				
				// Формирование табличной части скидок
				СуммаКРаспределению = НоваяСтрока.СуммаАвтоматическойСкидки;
				
				ЕстьСтрокаСкидки = Ложь;
				Если Выборка.КлючСвязи <> 0 Тогда
					Для Каждого СтрокаСкидкиЗаказа ИЗ СкидкиНаценкиЗаказа.НайтиСтроки(Новый Структура("Заказ,КлючСвязи", Выборка.ЗаказПокупателя, Выборка.КлючСвязи)) Цикл
						
						СтрокаСкидки = СкидкиНаценки.Добавить();
						ЗаполнитьЗначенияСвойств(СтрокаСкидки, СтрокаСкидкиЗаказа);
						СтрокаСкидки.Сумма = КоэффициентПересчетаСкидки * СтрокаСкидки.Сумма;
						СуммаКРаспределению = СуммаКРаспределению - СтрокаСкидки.Сумма;
						ЕстьСтрокаСкидки = Истина;
						
					КонецЦикла;
				КонецЕсли;
				
				Если ЕстьСтрокаСкидки И СуммаКРаспределению <> 0 Тогда
					СтрокаСкидки.Сумма = СтрокаСкидки.Сумма + СуммаКРаспределению;
				КонецЕсли;
			КонецЕсли;
			// Конец АвтоматическиеСкидки
			
			Если МассивСтрокОстатков[0].КоличествоОстаток <= 0 Тогда
				ТаблицаОстатков.Удалить(МассивСтрокОстатков[0]);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	// АвтоматическиеСкидки.
	Если ИспользоватьАвтоматическиеСкидки Тогда
		РезультатРасчетаСкидокНаценок = СкидкиНаценки.Выгрузить();
		СкидкиНаценкиСервер.ПрименитьРезультатРасчетаСкидокКОбъекту(ЭтотОбъект, "РаботыИУслуги", РезультатРасчетаСкидокНаценок);
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьПоЗаказуПокупателя()

// Обработчик заполнения на основании документа СчетНаОплату.
//
// Параметры:
//	ДокументСсылкаСчетНаОплату - ДокументСсылка.СчетНаОплату - счет на оплату.
//	
Процедура ЗаполнитьПоСчетуНаОплату(ДокументСсылкаСчетНаОплату) Экспорт
	
	ОснованиеСчетаНаОплату = ДокументСсылкаСчетНаОплату.ДокументОснование;
	Если ТипЗнч(ОснованиеСчетаНаОплату) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
		Если ОснованиеСчетаНаОплату.ВидОперации = Перечисления.ВидыОперацийЗаказПокупателя.ЗаказНаряд Тогда
			ВызватьИсключение НСтр("ru = 'Нельзя ввести Акт выполненных работ на основании Счета на оплату, выписанного на Заказ-наряд!'");;
		КонецЕсли;
	КонецЕсли;

	// Заполнение шапки документа.
	ЭтотОбъект.ДокументОснование = ДокументСсылкаСчетНаОплату.Ссылка;
	Организация = ДокументСсылкаСчетНаОплату.Организация;
	Контрагент = ДокументСсылкаСчетНаОплату.Контрагент;
	Договор = ДокументСсылкаСчетНаОплату.Договор;
	ВидЦен = ДокументСсылкаСчетНаОплату.ВидЦен;
	ВидСкидкиНаценки = ДокументСсылкаСчетНаОплату.ВидСкидкиНаценки;
	ВалютаДокумента = ДокументСсылкаСчетНаОплату.ВалютаДокумента;
	СуммаВключаетНДС = ДокументСсылкаСчетНаОплату.СуммаВключаетНДС;
	НалогообложениеНДС = ДокументСсылкаСчетНаОплату.НалогообложениеНДС;
	// ДисконтныеКарты
	ДисконтнаяКарта = ДокументСсылкаСчетНаОплату.ДисконтнаяКарта;
	ПроцентСкидкиПоДисконтнойКарте = ДокументСсылкаСчетНаОплату.ПроцентСкидкиПоДисконтнойКарте;
	// Конец ДисконтныеКарты
	
	Если ВалютаДокумента = Константы.НациональнаяВалюта.Получить() Тогда
		Курс = ДокументСсылкаСчетНаОплату.Курс;
		Кратность = ДокументСсылкаСчетНаОплату.Кратность;
	Иначе
		СтруктураПоВалюте = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(Дата, Новый Структура("Валюта", Договор.ВалютаРасчетов));
		Курс = СтруктураПоВалюте.Курс;
		Кратность = СтруктураПоВалюте.Кратность;
	КонецЕсли;
	
	ЗаказВТабличнойЧасти = НЕ УправлениеНебольшойФирмойПовтИсп.РеквизитВШапке("ПоложениеЗаказаПокупателяВДокументахОтгрузки");
	Если ТипЗнч(ДокументСсылкаСчетНаОплату.ДокументОснование) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
		ЗаказПокупателяДляЗаполнения = ДокументСсылкаСчетНаОплату.ДокументОснование;
	Иначе
		ЗаказПокупателяДляЗаполнения = Документы.ЗаказПокупателя.ПустаяСсылка();
	КонецЕсли;
	
	Если НЕ ЗаказВТабличнойЧасти Тогда
		ЗаказПокупателя = ЗаказПокупателяДляЗаполнения;
	КонецЕсли;
	
	// Заполнение табличной части документа.
	РаботыИУслуги.Очистить();
	Для каждого СтрокаТабличнойЧасти Из ДокументСсылкаСчетНаОплату.Запасы Цикл
		
		Если СтрокаТабличнойЧасти.Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Работа
			ИЛИ СтрокаТабличнойЧасти.Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Услуга Тогда
		
			НоваяСтрока = РаботыИУслуги.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТабличнойЧасти);
			
			Если ЗаказВТабличнойЧасти Тогда
				НоваяСтрока.ЗаказПокупателя = ЗаказПокупателяДляЗаполнения;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// АвтоматическиеСкидки
	Если ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическиеСкидкиНаценки") Тогда
		Для Каждого СтрокаСкидокНаценок Из ДокументСсылкаСчетНаОплату.СкидкиНаценки Цикл
			СтруктураПоиска = Новый Структура("КлючСвязи", );
			Если РаботыИУслуги.Найти(СтрокаСкидокНаценок.КлючСвязи, "КлючСвязи") <> Неопределено Тогда
				НоваяСтрокаСкидокНаценок = СкидкиНаценки.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрокаСкидокНаценок, СтрокаСкидокНаценок);
			КонецЕсли;
		КонецЦикла;
		СкидкиРассчитаны = ДокументСсылкаСчетНаОплату.СкидкиРассчитаны;
	КонецЕсли;
	// Конец АвтоматическиеСкидки
	
КонецПроцедуры // ЗаполнитьПоСчетуНаОплату()

Процедура ЗаполнитьПоПриемуВРемонт(ДокументСсылкаПриемВРемонт) Экспорт
	
	// Заполнение шапки документа.
	ЭтотОбъект.ДокументОснование = ДокументСсылкаПриемВРемонт.Ссылка;
	Организация = ДокументСсылкаПриемВРемонт.Организация;
	Контрагент = ДокументСсылкаПриемВРемонт.Контрагент;
	Договор = ДокументСсылкаПриемВРемонт.Договор;
	
	ВидЦен = Договор.ВидЦен;
	ВидСкидкиНаценки = Договор.ВидСкидкиНаценки;
	ВалютаДокумента = Договор.ВалютаРасчетов;
	СуммаВключаетНДС = ?(ЗначениеЗаполнено(Договор.ВидЦен), Договор.ВидЦен.ЦенаВключаетНДС, Неопределено);
	НалогообложениеНДС = УправлениеНебольшойФирмойСервер.НалогообложениеНДС(Организация,, Дата);
	
	СтруктураПоВалюте = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(Дата, Новый Структура("Валюта", Договор.ВалютаРасчетов));
	Курс = СтруктураПоВалюте.Курс;
	Кратность = СтруктураПоВалюте.Кратность;
	
КонецПроцедуры

Процедура ЗаполнитьПоСтруктуре(ДанныеЗаполнения) Экспорт
	
	Если ДанныеЗаполнения.Свойство("МассивЗаказовПокупателей") Тогда
		ЗаполнитьПоЗаказуПокупателя(ДанныеЗаполнения)
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗаказВШапке = ПоложениеЗаказаПокупателя = Перечисления.ПоложениеРеквизитаНаФорме.ВШапке;
	
	ТаблицаРаботыИУслуги = РаботыИУслуги.Выгрузить(, "ЗаказПокупателя, Всего");
	ТаблицаРаботыИУслуги.Свернуть("ЗаказПокупателя", "Всего");
	
	ТаблицаПредоплата = Предоплата.Выгрузить(, "Заказ, СуммаПлатежа");
	ТаблицаПредоплата.Свернуть("Заказ", "СуммаПлатежа");
	
	Если ЗаказВШапке Тогда
		Для каждого СтрокаРаботыИУслуги Из ТаблицаРаботыИУслуги Цикл
			СтрокаРаботыИУслуги.ЗаказПокупателя = ЗаказПокупателя;
		КонецЦикла;
		Если Контрагент.ВестиРасчетыПоЗаказам Тогда
			Для каждого СтрокаПредоплата Из ТаблицаПредоплата Цикл
				СтрокаПредоплата.Заказ = ЗаказПокупателя;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	// Скидка 100%.
	ЕстьРучныеСкидки = ПолучитьФункциональнуюОпцию("ИспользоватьРучныеСкидкиНаценкиПродажи");
	ЕстьАвтоматическиеСкидки = ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическиеСкидкиНаценки"); // АвтоматическиеСкидки
	Если ЕстьРучныеСкидки ИЛИ ЕстьАвтоматическиеСкидки Тогда
		Для каждого СтрокаРаботыИУслуги Из РаботыИУслуги Цикл
			// АвтоматическиеСкидки
			ТекСумма = СтрокаРаботыИУслуги.Цена * СтрокаРаботыИУслуги.Количество;
			ТекСуммаРучнойСкидки = ?(ЕстьРучныеСкидки, ОКР(ТекСумма * СтрокаРаботыИУслуги.ПроцентСкидкиНаценки / 100, 2), 0);
			ТекСуммаАвтоматическойСкидки = ?(ЕстьАвтоматическиеСкидки, СтрокаРаботыИУслуги.СуммаАвтоматическойСкидки, 0);
			ТекСуммаСкидки = ТекСуммаРучнойСкидки + ТекСуммаАвтоматическойСкидки;
			Если СтрокаРаботыИУслуги.ПроцентСкидкиНаценки <> 100 И ТекСуммаСкидки < ТекСумма
				И НЕ ЗначениеЗаполнено(СтрокаРаботыИУслуги.Сумма) Тогда
				ТекстСообщения = НСтр("ru = 'Не заполнена колонка ""Сумма"" в строке %Номер% списка ""Работы и услуги"".'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Номер%", СтрокаРаботыИУслуги.НомерСтроки);
				УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
					ЭтотОбъект,
					ТекстСообщения,
					"РаботыИУслуги",
					СтрокаРаботыИУслуги.НомерСтроки,
					"Сумма",
					Отказ
				);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	КоличествоРаботыИУслуги = РаботыИУслуги.Количество();
	
	Для каждого Строка Из ТаблицаПредоплата Цикл
		
		НайденнаяСтрокаРаботыИУслуги = Неопределено;
		
		Если Контрагент.ВестиРасчетыПоЗаказам
		   И Строка.Заказ <> Неопределено
		   И Строка.Заказ <> Документы.ЗаказПокупателя.ПустаяСсылка()
		   И Строка.Заказ <> Документы.ЗаказПоставщику.ПустаяСсылка() Тогда
			НайденнаяСтрокаРаботыИУслуги = ТаблицаРаботыИУслуги.Найти(Строка.Заказ, "ЗаказПокупателя");
			Всего = ?(НайденнаяСтрокаРаботыИУслуги = Неопределено, 0, НайденнаяСтрокаРаботыИУслуги.Всего);
		ИначеЕсли Контрагент.ВестиРасчетыПоЗаказам Тогда
			НайденнаяСтрокаРаботыИУслуги = ТаблицаРаботыИУслуги.Найти(Неопределено, "ЗаказПокупателя");
			НайденнаяСтрокаРаботыИУслуги = ?(НайденнаяСтрокаРаботыИУслуги = Неопределено, ТаблицаРаботыИУслуги.Найти(Документы.ЗаказПокупателя.ПустаяСсылка(), "ЗаказПокупателя"), НайденнаяСтрокаРаботыИУслуги);
			Всего = ?(НайденнаяСтрокаРаботыИУслуги = Неопределено, 0, НайденнаяСтрокаРаботыИУслуги.Всего);
		Иначе
			Всего = РаботыИУслуги.Итог("Всего");
		КонецЕсли;
		
		Если НайденнаяСтрокаРаботыИУслуги = Неопределено
		   И КоличествоРаботыИУслуги > 0
		   И Контрагент.ВестиРасчетыПоЗаказам Тогда
			ТекстСообщения = НСтр("ru = 'Нельзя зачесть аванс по заказу отличному от указанных в табличной части ""Работы и услуги""!'");
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
				,
				ТекстСообщения,
				Неопределено,
				Неопределено,
				"ПредоплатаИтогСуммаРасчетовВалюта",
				Отказ
			);
		КонецЕсли;
		
	КонецЦикла;
	
	Если НЕ Контрагент.ВестиРасчетыПоДоговорам Тогда
		УправлениеНебольшойФирмойСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Договор");
	КонецЕсли;
	
	// Биллинг
	Если ПолучитьФункциональнуюОпцию("ИспользоватьБиллинг") И Договор.ЭтоДоговорОбслуживания Тогда
		Для Каждого Стр Из РаботыИУслуги Цикл
			Если НЕ УправлениеНебольшойФирмойСервер.РазрешенаПродажаНоменклатурыПоДоговоруОбслуживания(Договор, Стр.Номенклатура, Стр.Характеристика) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru = 'Запрещено проводить незапланированные услуги/работы по текущему договору обслуживания!'"),
					Договор.ДоговорОбслуживанияТарифныйПлан,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("РаботыИУслуги", Стр.НомерСтроки, "Номенклатура"),,
					Отказ
				);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Процедура - обработчик события ОбработкаЗаполнения.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("Структура")] = "ЗаполнитьПоСтруктуре";
	СтратегияЗаполнения[Тип("ДокументСсылка.ЗаказПокупателя")] = "ЗаполнитьПоЗаказуПокупателя";
	СтратегияЗаполнения[Тип("ДокументСсылка.СчетНаОплату")] = "ЗаполнитьПоСчетуНаОплату";
	СтратегияЗаполнения[Тип("ДокументСсылка.ПриемИПередачаВРемонт")] = "ЗаполнитьПоПриемуВРемонт";
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
КонецПроцедуры // ОбработкаЗаполнения()

// Процедура - обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПоложениеЗаказаПокупателя = Перечисления.ПоложениеРеквизитаНаФорме.ВШапке Тогда
		Для каждого СтрокаТабличнойЧасти Из РаботыИУслуги Цикл
			СтрокаТабличнойЧасти.ЗаказПокупателя = ЗаказПокупателя;
		КонецЦикла;
		Если Контрагент.ВестиРасчетыПоЗаказам Тогда
			Для каждого СтрокаТабличнойЧасти Из Предоплата Цикл
				СтрокаТабличнойЧасти.Заказ = ЗаказПокупателя;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Контрагент)
	И НЕ Контрагент.ВестиРасчетыПоДоговорам
	И НЕ ЗначениеЗаполнено(Договор) Тогда
		Договор = Контрагент.ДоговорПоУмолчанию;
	КонецЕсли;
	
	СуммаДокумента = РаботыИУслуги.Итог("Всего");
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.АктВыполненныхРабот.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	УправлениеНебольшойФирмойСервер.ОтразитьЗапасы(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьВыпускПродукции(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьПродажи(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьЗаказыПокупателей(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДоходыИРасходы(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьРасчетыСПокупателями(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДоходыИРасходыКассовыйМетод(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДоходыИРасходыНераспределенные(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДоходыИРасходыОтложенные(ДополнительныеСвойства, Движения, Отказ);
	
	УправлениеНебольшойФирмойСервер.ОтразитьУправленческий(ДополнительныеСвойства, Движения, Отказ);
	
	// ДисконтныеКарты
	УправлениеНебольшойФирмойСервер.ОтразитьПродажиПоДисконтнойКарте(ДополнительныеСвойства, Движения, Отказ);
	// АвтоматическиеСкидки
	УправлениеНебольшойФирмойСервер.ОтразитьПредоставленныеАвтоматическиеСкидки(ДополнительныеСвойства, Движения, Отказ);
	// Эквайринг
	УправлениеНебольшойФирмойСервер.ОтразитьДоходыИРасходыКассовыйМетодЭквайринг(ДополнительныеСвойства, Движения, Отказ);
	
	// Рублевые суммы документов
	УправлениеНебольшойФирмойСервер.ОтразитьРублевыеСуммыДокументовВВалюте(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей.
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательного остатка.
	Документы.АктВыполненныхРабот.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры // ОбработкаПроведения()

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа.
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей.
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательного остатка.
	Документы.АктВыполненныхРабот.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);
	
	// Подчиненная счет-фактура
	Если НЕ Отказ Тогда
		
		КонтрольПодчиненнойСчетФактуры();
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаУдаленияПроведения()

// Процедура - обработчик события ПриКопировании объекта.
//
Процедура ПриКопировании(ОбъектКопирования)
	
	Предоплата.Очистить();
	
КонецПроцедуры // ПриКопировании()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура отмены проведения у подченненой счет фактуры
//
Процедура КонтрольПодчиненнойСчетФактуры()
	
	СтруктураСчетаФактуры = УправлениеНебольшойФирмойСервер.ПолучитьПодчиненныйСчетФактуру(Ссылка);
	Если СтруктураСчетаФактуры = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СчетФактура	 = СтруктураСчетаФактуры.Ссылка;
	Если Не СчетФактура.Проведен Тогда
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = НСтр("ru = 'В связи с отсутствием движений у документа %ПредставлениеТекущегоДокумента% распроводится счет фактура %ПредставлениеСчетФактуры%.'");
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПредставлениеТекущегоДокумента%", """Акт выполненных работ  № " + Номер + " от " + Формат(Дата, "ДФ=dd.MM.yyyy") + """");
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПредставлениеСчетФактуры%", """Счет фактура (выданная) № " + СтруктураСчетаФактуры.Номер + " от " + СтруктураСчетаФактуры.Дата + """");
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
	СчетФактураОбъект = СчетФактура.ПолучитьОбъект();
	СчетФактураОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
	
КонецПроцедуры //КонтрольПодчиненнойСчетФактуры()

#КонецОбласти

#КонецЕсли
