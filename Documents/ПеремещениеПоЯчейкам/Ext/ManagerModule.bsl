﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылкаПеремещениеПоЯчейкам, СтруктураДополнительныеСвойства) Экспорт

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПеремещениеПоЯчейкамЗапасы.НомерСтроки КАК НомерСтроки,
	|	ПеремещениеПоЯчейкамЗапасы.КлючСвязи КАК КлючСвязи,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ПеремещениеПоЯчейкамЗапасы.Ссылка.Дата КАК Период,
	|	&Организация КАК Организация,
	|	ПеремещениеПоЯчейкамЗапасы.Ссылка.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ВЫБОР
	|		КОГДА ПеремещениеПоЯчейкамЗапасы.Ссылка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПеремещениеПоЯчейкам.ИзОднойВНесколько)
	|			ТОГДА ПеремещениеПоЯчейкамЗапасы.Ссылка.Ячейка
	|		ИНАЧЕ ПеремещениеПоЯчейкамЗапасы.Ячейка
	|	КОНЕЦ КАК Ячейка,
	|	ВЫБОР
	|		КОГДА ПеремещениеПоЯчейкамЗапасы.Ссылка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПеремещениеПоЯчейкам.ИзОднойВНесколько)
	|			ТОГДА ПеремещениеПоЯчейкамЗапасы.Ячейка
	|		ИНАЧЕ ПеремещениеПоЯчейкамЗапасы.Ссылка.Ячейка
	|	КОНЕЦ КАК ЯчейкаПолучатель,
	|	ПеремещениеПоЯчейкамЗапасы.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА &ИспользоватьХарактеристики
	|			ТОГДА ПеремещениеПоЯчейкамЗапасы.Характеристика
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Характеристика,
	|	ВЫБОР
	|		КОГДА &ИспользоватьПартии
	|			ТОГДА ПеремещениеПоЯчейкамЗапасы.Партия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ПартииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Партия,
	|	ПеремещениеПоЯчейкамЗапасы.Количество КАК Количество
	|ИЗ
	|	Документ.ПеремещениеПоЯчейкам.Запасы КАК ПеремещениеПоЯчейкамЗапасы
	|ГДЕ
	|	ПеремещениеПоЯчейкамЗапасы.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаЗапасы.Ссылка.Дата КАК ДатаСобытия,
	|	ЗНАЧЕНИЕ(Перечисление.ОперацииСерийныхНомеров.Движение) КАК Операция,
	|	ТаблицаСерийныеНомера.СерийныйНомер КАК СерийныйНомер,
	|	ТаблицаЗапасы.Номенклатура КАК Номенклатура,
	|	ТаблицаЗапасы.Характеристика КАК Характеристика
	|ИЗ
	|	Документ.ПеремещениеПоЯчейкам.Запасы КАК ТаблицаЗапасы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПеремещениеПоЯчейкам.СерийныеНомера КАК ТаблицаСерийныеНомера
	|		ПО ТаблицаЗапасы.Ссылка = ТаблицаСерийныеНомера.Ссылка
	|			И ТаблицаЗапасы.КлючСвязи = ТаблицаСерийныеНомера.КлючСвязи
	|ГДЕ
	|	ТаблицаСерийныеНомера.Ссылка = &Ссылка
	|	И &ИспользоватьСерийныеНомера
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаЗапасы.Ссылка.Дата КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ТаблицаСерийныеНомера.СерийныйНомер КАК СерийныйНомер,
	|	&Организация КАК Организация,
	|	ТаблицаЗапасы.Номенклатура КАК Номенклатура,
	|	ТаблицаЗапасы.Характеристика КАК Характеристика,
	|	ТаблицаЗапасы.Партия КАК Партия,
	|	ТаблицаЗапасы.Ссылка.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ВЫБОР
	|		КОГДА ТаблицаЗапасы.Ссылка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПеремещениеПоЯчейкам.ИзОднойВНесколько)
	|			ТОГДА ТаблицаЗапасы.Ссылка.Ячейка
	|		ИНАЧЕ ТаблицаЗапасы.Ячейка
	|	КОНЕЦ КАК Ячейка,
	|	1 КАК Количество
	|ИЗ
	|	Документ.ПеремещениеПоЯчейкам.Запасы КАК ТаблицаЗапасы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПеремещениеПоЯчейкам.СерийныеНомера КАК ТаблицаСерийныеНомера
	|		ПО ТаблицаЗапасы.Ссылка = ТаблицаСерийныеНомера.Ссылка
	|			И ТаблицаЗапасы.КлючСвязи = ТаблицаСерийныеНомера.КлючСвязи
	|ГДЕ
	|	ТаблицаСерийныеНомера.Ссылка = &Ссылка
	|	И &ИспользоватьСерийныеНомера
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаЗапасы.Ссылка.Дата,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
	|	ТаблицаСерийныеНомера.СерийныйНомер,
	|	&Организация КАК Организация,
	|	ТаблицаЗапасы.Номенклатура,
	|	ТаблицаЗапасы.Характеристика,
	|	ТаблицаЗапасы.Партия КАК Партия,
	|	ТаблицаЗапасы.Ссылка.СтруктурнаяЕдиница,
	|	ВЫБОР
	|		КОГДА ТаблицаЗапасы.Ссылка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПеремещениеПоЯчейкам.ИзОднойВНесколько)
	|			ТОГДА ТаблицаЗапасы.Ячейка
	|		ИНАЧЕ ТаблицаЗапасы.Ссылка.Ячейка
	|	КОНЕЦ,
	|	1
	|ИЗ
	|	Документ.ПеремещениеПоЯчейкам.Запасы КАК ТаблицаЗапасы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПеремещениеПоЯчейкам.СерийныеНомера КАК ТаблицаСерийныеНомера
	|		ПО ТаблицаЗапасы.Ссылка = ТаблицаСерийныеНомера.Ссылка
	|			И ТаблицаЗапасы.КлючСвязи = ТаблицаСерийныеНомера.КлючСвязи
	|ГДЕ
	|	ТаблицаСерийныеНомера.Ссылка = &Ссылка
	|	И &ИспользоватьСерийныеНомера");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаПеремещениеПоЯчейкам);
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.Дляпроведения.Организация);
	Запрос.УстановитьПараметр("ИспользоватьХарактеристики", СтруктураДополнительныеСвойства.УчетнаяПолитика.ИспользоватьХарактеристики);
	Запрос.УстановитьПараметр("ИспользоватьПартии", СтруктураДополнительныеСвойства.УчетнаяПолитика.ИспользоватьПартии);
	
	Запрос.УстановитьПараметр("ИспользоватьСерийныеНомера", СтруктураДополнительныеСвойства.УчетнаяПолитика.ИспользоватьСерийныеНомера);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаЗапасыНаСкладах", МассивРезультатов[0].Выгрузить());
	Выборка = МассивРезультатов[0].Выбрать();
	Пока Выборка.Следующий() Цикл
			
		НоваяСтрока = СтруктураДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаЗапасыНаСкладах.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		НоваяСтрока.ВидДвижения = ВидДвиженияНакопления.Приход;
		НоваяСтрока.Ячейка = Выборка.ЯчейкаПолучатель;
		
	КонецЦикла;
	
	// Серийные номера
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСерийныеНомераГарантии", МассивРезультатов[1].Выгрузить());
	Если СтруктураДополнительныеСвойства.УчетнаяПолитика.ОстаткиСерийныхНомеров Тогда
		СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСерийныеНомераОстатки", МассивРезультатов[2].Выгрузить());
	Иначе
		СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСерийныеНомераОстатки", Новый ТаблицаЗначений);
	КонецЕсли;
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

// Выполняет контроль возникновения отрицательных остатков.
//
Процедура ВыполнитьКонтроль(ДокументСсылкаПеремещениеПоЯчейкам, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	
	Если Не УправлениеНебольшойФирмойСервер.ВыполнитьКонтрольОстатков() Тогда
		Возврат;
	КонецЕсли;

	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Если временные таблицы "ДвиженияЗапасыНаСкладахИзменение", "ДвиженияЗапасыИзменение"
	// содержат записи, необходимо выполнить контроль реализации товаров.
	
	Если СтруктураВременныеТаблицы.ДвиженияЗапасыНаСкладахИзменение Тогда

		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДвиженияЗапасыНаСкладахИзменение.НомерСтроки КАК НомерСтроки,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыНаСкладахИзменение.Организация) КАК ОрганизацияПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыНаСкладахИзменение.СтруктурнаяЕдиница) КАК СтруктурнаяЕдиницаПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыНаСкладахИзменение.Номенклатура) КАК НоменклатураПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыНаСкладахИзменение.Характеристика) КАК ХарактеристикаПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыНаСкладахИзменение.Партия) КАК ПартияПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыНаСкладахИзменение.Ячейка) КАК ЯчейкаПредставление,
		|	ЗапасыНаСкладахОстатки.СтруктурнаяЕдиница.ТипСтруктурнойЕдиницы КАК ТипСтруктурнойЕдиницы,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ЗапасыНаСкладахОстатки.Номенклатура.ЕдиницаИзмерения) КАК ЕдиницаИзмеренияПредставление,
		|	ЕСТЬNULL(ДвиженияЗапасыНаСкладахИзменение.КоличествоИзменение, 0) + ЕСТЬNULL(ЗапасыНаСкладахОстатки.КоличествоОстаток, 0) КАК ОстатокЗапасыНаСкладах,
		|	ЕСТЬNULL(ЗапасыНаСкладахОстатки.КоличествоОстаток, 0) КАК КоличествоОстатокЗапасыНаСкладах
		|ИЗ
		|	ДвиженияЗапасыНаСкладахИзменение КАК ДвиженияЗапасыНаСкладахИзменение
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗапасыНаСкладах.Остатки(
		|				&МоментКонтроля,
		|				(Организация, СтруктурнаяЕдиница, Номенклатура, Характеристика, Партия, Ячейка) В
		|					(ВЫБРАТЬ
		|						ДвиженияЗапасыНаСкладахИзменение.Организация КАК Организация,
		|						ДвиженияЗапасыНаСкладахИзменение.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
		|						ДвиженияЗапасыНаСкладахИзменение.Номенклатура КАК Номенклатура,
		|						ДвиженияЗапасыНаСкладахИзменение.Характеристика КАК Характеристика,
		|						ДвиженияЗапасыНаСкладахИзменение.Партия КАК Партия,
		|						ДвиженияЗапасыНаСкладахИзменение.Ячейка КАК Ячейка
		|					ИЗ
		|						ДвиженияЗапасыНаСкладахИзменение КАК ДвиженияЗапасыНаСкладахИзменение)) КАК ЗапасыНаСкладахОстатки
		|		ПО ДвиженияЗапасыНаСкладахИзменение.Организация = ЗапасыНаСкладахОстатки.Организация
		|			И ДвиженияЗапасыНаСкладахИзменение.СтруктурнаяЕдиница = ЗапасыНаСкладахОстатки.СтруктурнаяЕдиница
		|			И ДвиженияЗапасыНаСкладахИзменение.Номенклатура = ЗапасыНаСкладахОстатки.Номенклатура
		|			И ДвиженияЗапасыНаСкладахИзменение.Характеристика = ЗапасыНаСкладахОстатки.Характеристика
		|			И ДвиженияЗапасыНаСкладахИзменение.Партия = ЗапасыНаСкладахОстатки.Партия
		|			И ДвиженияЗапасыНаСкладахИзменение.Ячейка = ЗапасыНаСкладахОстатки.Ячейка
		|ГДЕ
		|	ЕСТЬNULL(ЗапасыНаСкладахОстатки.КоличествоОстаток, 0) < 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки");

		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.УстановитьПараметр("МоментКонтроля", ДополнительныеСвойства.ДляПроведения.МоментКонтроля);
		
		МассивРезультатов = Запрос.ВыполнитьПакет();

		// Отрицательный остаток запасов на складе.
		Если НЕ МассивРезультатов[0].Пустой() Тогда
			ДокументОбъектПеремещениеПоЯчейкам = ДокументСсылкаПеремещениеПоЯчейкам.ПолучитьОбъект();
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[0].Выбрать();
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибкахПроведенияПоРегиструЗапасыНаСкладахСписком(ДокументОбъектПеремещениеПоЯчейкам, ВыборкаИзРезультатаЗапроса, Отказ);
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры // ВыполнитьКонтроль()

#Область ИнтерфейсПечати

// Процедура формирования табличного документа
//
Процедура СформироватьПеремещениеЗапасовПоЯчейкам(ТекущийДокумент, ТабличныйДокумент, ИмяМакета)
	
	СтруктураЗаполненияСекции = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", ТекущийДокумент);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПеремещениеПоЯчейкам.Номер КАК НомерДокумента,
	|	ПеремещениеПоЯчейкам.Дата КАК ДатаДокумента,
	|	ПеремещениеПоЯчейкам.ВидОперации КАК ВидОперации,
	|	ПеремещениеПоЯчейкам.Организация КАК Организация,
	|	ПеремещениеПоЯчейкам.Организация.Префикс КАК Префикс,
	|	ПеремещениеПоЯчейкам.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ПеремещениеПоЯчейкам.СтруктурнаяЕдиница.МОЛ КАК МОЛ,
	|	ПеремещениеПоЯчейкам.Ячейка КАК Ячейка
	|ИЗ
	|	Документ.ПеремещениеПоЯчейкам КАК ПеремещениеПоЯчейкам
	|ГДЕ
	|	ПеремещениеПоЯчейкам.Ссылка = &ТекущийДокумент
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПеремещениеПоЯчейкамЗапасы.НомерСтроки,
	|	ПеремещениеПоЯчейкамЗапасы.Ячейка,
	|	ПеремещениеПоЯчейкамЗапасы.Номенклатура.Код КАК КодНоменклатуры,
	|	ПеремещениеПоЯчейкамЗапасы.Номенклатура.Артикул КАК АртикулНоменклатуры,
	|	ПеремещениеПоЯчейкамЗапасы.Номенклатура,
	|	ПеремещениеПоЯчейкамЗапасы.Характеристика,
	|	ПРЕДСТАВЛЕНИЕ(ПеремещениеПоЯчейкамЗапасы.Партия) КАК Партия,
	|	ПеремещениеПоЯчейкамЗапасы.Количество,
	|	ПеремещениеПоЯчейкамЗапасы.ЕдиницаИзмерения,
	|	ПеремещениеПоЯчейкамЗапасы.КлючСвязи
	|ИЗ
	|	Документ.ПеремещениеПоЯчейкам.Запасы КАК ПеремещениеПоЯчейкамЗапасы
	|ГДЕ
	|	ПеремещениеПоЯчейкамЗапасы.Ссылка = &ТекущийДокумент
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПеремещениеПоЯчейкамЗапасы.Ссылка,
	|	МАКСИМУМ(ПеремещениеПоЯчейкамЗапасы.НомерСтроки) КАК КоличествоПозиций,
	|	СУММА(ПеремещениеПоЯчейкамЗапасы.Количество) КАК ИтогКоличество
	|ИЗ
	|	Документ.ПеремещениеПоЯчейкам.Запасы КАК ПеремещениеПоЯчейкамЗапасы
	|ГДЕ
	|	ПеремещениеПоЯчейкамЗапасы.Ссылка = &ТекущийДокумент
	|
	|СГРУППИРОВАТЬ ПО
	|	ПеремещениеПоЯчейкамЗапасы.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПеремещениеПоЯчейкамСерийныеНомера.СерийныйНомер,
	|	ПеремещениеПоЯчейкамСерийныеНомера.КлючСвязи
	|ИЗ
	|	Документ.ПеремещениеПоЯчейкам.СерийныеНомера КАК ПеремещениеПоЯчейкамСерийныеНомера
	|ГДЕ
	|	ПеремещениеПоЯчейкамСерийныеНомера.Ссылка = &ТекущийДокумент";
	
	РезультатВыполнения = Запрос.ВыполнитьПакет();
	
	ШапкаДокумента = РезультатВыполнения[0].Выбрать();
	ШапкаДокумента.Следующий();
	
	ТабличнаяЧасть = РезультатВыполнения[1].Выбрать();
	
	ВыборкаИтогов = РезультатВыполнения[2].Выбрать();
	ВыборкаИтогов.Следующий();
	
	ВыборкаСерийныеНомера = РезультатВыполнения[3].Выбрать();
	
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_" + ИмяМакета + "_" + ИмяМакета;
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПеремещениеПоЯчейкам." + ИмяМакета);
	
	//::: Заголовок
	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	Если ШапкаДокумента.ДатаДокумента < Дата('20110101') Тогда
		
		НомерДокумента = УправлениеНебольшойФирмойСервер.ПолучитьНомерНаПечать(ШапкаДокумента.НомерДокумента, ШапкаДокумента.Префикс);
		
	Иначе
		
		НомерДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ШапкаДокумента.НомерДокумента, Истина, Истина);
		
	КонецЕсли;
	
	ТекстЗаголовка = Нстр("ru = 'Перемещение запасов по ячейкам № '") + ШапкаДокумента.НомерДокумента + Нстр("ru = ' от '") + Формат(ШапкаДокумента.ДатаДокумента, "ДЛФ=DD");
	СтруктураЗаполненияСекции.Вставить("ТекстЗаголовка", ТекстЗаголовка);
	СтруктураЗаполненияСекции.Вставить("СтруктурнаяЕдиница", ШапкаДокумента.СтруктурнаяЕдиница);
	
	ОбластьМакета.Параметры.Заполнить(СтруктураЗаполненияСекции);
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	//::: Шапка таблицы
	ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
	СтруктураЗаполненияСекции.Очистить();
	
	СтруктураЗаполненияСекции.Вставить("ВидПеремещения", Нстр("ru = 'Вид перемещения: '") + Строка(ШапкаДокумента.ВидОперации));
	
	ОбластьМакета.Параметры.Заполнить(СтруктураЗаполненияСекции);
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	//::: Строки таблицы
	ОбластьМакета = Макет.ПолучитьОбласть("СтрокаТаблицы");
	ЭтоПеремещениеИзОднойВНесколько = (ШапкаДокумента.ВидОперации = Перечисления.ВидыОперацийПеремещениеПоЯчейкам.ИзОднойВНесколько);
	Пока ТабличнаяЧасть.Следующий() Цикл
		
		СтруктураЗаполненияСекции.Очистить();
		СтруктураЗаполненияСекции.Вставить("НомерСтроки", ТабличнаяЧасть.НомерСтроки);
		
		ЯчейкаОтправитель = ?(ЭтоПеремещениеИзОднойВНесколько,	ШапкаДокумента.Ячейка, ТабличнаяЧасть.Ячейка);
		ЯчейкаПолучать = ?(ЭтоПеремещениеИзОднойВНесколько, 	ТабличнаяЧасть.Ячейка, ШапкаДокумента.Ячейка);
		
		СтруктураЗаполненияСекции.Вставить("ЯчейкаОтправитель", ЯчейкаОтправитель);
		СтруктураЗаполненияСекции.Вставить("ЯчейкаПолучать", ЯчейкаПолучать);
		
		СтрокаСерийныеНомера = РаботаССерийнымиНомерами.СтрокаСерийныеНомераИзВыборки(ВыборкаСерийныеНомера, ТабличнаяЧасть.КлючСвязи);
		ПредставлениеНоменклатуры = УправлениеНебольшойФирмойСервер.ПолучитьПредставлениеНоменклатурыДляПечати(ТабличнаяЧасть.Номенклатура, 
			ТабличнаяЧасть.Характеристика, ТабличнаяЧасть.АртикулНоменклатуры, СтрокаСерийныеНомера);
			
		СтруктураЗаполненияСекции.Вставить("ПредставлениеНоменклатуры", ПредставлениеНоменклатуры);
		СтруктураЗаполненияСекции.Вставить("ПредставлениеПартии", ТабличнаяЧасть.Партия);
		СтруктураЗаполненияСекции.Вставить("Количество", ТабличнаяЧасть.Количество);
		СтруктураЗаполненияСекции.Вставить("ЕдиницаИзмерения", ТабличнаяЧасть.ЕдиницаИзмерения);
		
		ОбластьМакета.Параметры.Заполнить(СтруктураЗаполненияСекции);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
	КонецЦикла;
	
	//::: Подвал таблицы
	ОбластьМакета = Макет.ПолучитьОбласть("ПодвалТаблицы");
	СтруктураЗаполненияСекции.Очистить();
	
	СтруктураЗаполненияСекции.Вставить("ИтогКоличество", ВыборкаИтогов.ИтогКоличество);
	
	Если ВыборкаИтогов.ИтогКоличество = 0 Тогда
		
		КоличествоПеремещеныхЗапасовПрописью = Нстр("ru = 'В документе не указаны перемещаемые запасы.'");
		
	ИначеЕсли ЭтоПеремещениеИзОднойВНесколько Тогда
		
		КоличествоПеремещеныхЗапасовПрописью = Нстр("ru = 'Из ячейки ""%1"" изъято позиций: %2.
			|Общим количеством: %3.'");
		
	Иначе
		
		КоличествоПеремещеныхЗапасовПрописью = Нстр("ru = 'В ячейку ""%1"" поступило позиций: %2.
			|Общим количеством: %3.'");
		
	КонецЕсли;
	
	КоличествоПеремещеныхЗапасовПрописью = 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(КоличествоПеремещеныхЗапасовПрописью
			,ШапкаДокумента.Ячейка
			,?(ВыборкаИтогов.КоличествоПозиций = Неопределено, 0, ВыборкаИтогов.КоличествоПозиций)
			,ЧислоПрописью(?(ВыборкаИтогов.ИтогКоличество = Неопределено, 0, ВыборкаИтогов.ИтогКоличество), "L= ru_RU;SN=true;FN=false;FS=false", "единица, единицы, единиц, ж, , , , , 0")
		);
	
	СтруктураЗаполненияСекции.Вставить("КоличествоПеремещеныхЗапасовПрописью", КоличествоПеремещеныхЗапасовПрописью);
	
	ОбластьМакета.Параметры.Заполнить(СтруктураЗаполненияСекции);
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	//::: Подписи
	ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
	СтруктураЗаполненияСекции.Очистить();
	
	ПредставлениеМОЛ = РегистрыСведений.ФИОФизЛиц.ФИОФизЛица(ШапкаДокумента.ДатаДокумента, ШапкаДокумента.МОЛ);
	
	СтруктураЗаполненияСекции.Вставить("ОтветственныйПредставление", ПредставлениеМОЛ);
	СтруктураЗаполненияСекции.Вставить("ПолучилПредставление", ПредставлениеМОЛ);
	
	ОбластьМакета.Параметры.Заполнить(СтруктураЗаполненияСекции);
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
КонецПроцедуры // СформироватьПеремещениеЗапасовПоЯчейкам()

// Процедура печати документа
//
Функция ПечатьДокумента(МассивОбъектов, ОбъектыПечати, ИмяМакета)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ПервыйДокумент = Истина;
	НомерСтрокиНачало = 0;
	
	Для каждого ТекущийДокумент Из МассивОбъектов Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Если ИмяМакета = "ПФ_MXL_ПеремещениеЗапасовПоЯчейкам" Тогда
			
			СформироватьПеремещениеЗапасовПоЯчейкам(ТекущийДокумент, ТабличныйДокумент, ИмяМакета);
			
		КонецЕсли;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ТекущийДокумент);
		
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	Возврат ТабличныйДокумент;

КонецФункции // ПечатьДокумента()

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ЗаполнитьПараметрыЭлектроннойПочты = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПеремещениеЗапасовПоЯчейкам") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПеремещениеЗапасовПоЯчейкам", "Перемещение запасов по ячейкам", ПечатьДокумента(МассивОбъектов, ОбъектыПечати, "ПФ_MXL_ПеремещениеЗапасовПоЯчейкам"));
		
	КонецЕсли;
	
	// параметры отправки печатных форм по электронной почте
	Если ЗаполнитьПараметрыЭлектроннойПочты Тогда
		
		УправлениеНебольшойФирмойСервер.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, МассивОбъектов, КоллекцияПечатныхФорм);
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПеремещениеЗапасовПоЯчейкам";
	КомандаПечати.Представление = НСтр("ru = 'Перемещение запасов по ячейкам'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Порядок = 1;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли