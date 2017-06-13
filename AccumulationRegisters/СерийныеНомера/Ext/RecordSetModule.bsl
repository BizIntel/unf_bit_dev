﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ПередЗаписью набора записей.
//
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
		ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Установка исключительной блокировки текущего набора записей регистратора.
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.СерийныеНомера.НаборЗаписей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Регистратор", Отбор.Регистратор.Значение);
	Блокировка.Заблокировать();
	
	Если НЕ СтруктураВременныеТаблицы.Свойство("ДвиженияСерийныеНомераИзменение") ИЛИ
		СтруктураВременныеТаблицы.Свойство("ДвиженияСерийныеНомераИзменение") И НЕ СтруктураВременныеТаблицы.ДвиженияСерийныеНомераИзменение Тогда
		
		// Если временная таблица "ДвиженияСерийныеНомераИзменение" не существует или не содержит записей
		// об изменении набора, значит набор записывается первый раз или для набора был выполнен контроль остатков.
		// Текущее состояние набора помещается во временную таблицу "ДвиженияСерийныеНомераПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно текущего.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СерийныеНомера.НомерСтроки КАК НомерСтроки,
		|	СерийныеНомера.Номенклатура КАК Номенклатура,
		|	СерийныеНомера.Характеристика КАК Характеристика,
		|	СерийныеНомера.Партия КАК Партия,
		|	СерийныеНомера.СерийныйНомер КАК СерийныйНомер,
		|	СерийныеНомера.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
		|	СерийныеНомера.Ячейка КАК Ячейка,
		|	ВЫБОР
		|		КОГДА СерийныеНомера.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА СерийныеНомера.Количество
		|		ИНАЧЕ -СерийныеНомера.Количество
		|	КОНЕЦ КАК КоличествоПередЗаписью
		|ПОМЕСТИТЬ ДвиженияСерийныеНомераПередЗаписью
		|ИЗ
		|	РегистрНакопления.СерийныеНомера КАК СерийныеНомера
		|ГДЕ
		|	СерийныеНомера.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	Иначе
		
		// Если временная таблица "ДвиженияСерийныеНомераИзменение" существует и содержит записи
		// об изменении набора, значит набор записывается не первый раз и для набора не был выполнен контроль остатков.
		// Текущее состояние набора и текущее состояние изменений помещаются во временную таблцу "ДвиженияСерийныеНомераПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно первоначального.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДвиженияСерийныеНомераИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияСерийныеНомераИзменение.Номенклатура КАК Номенклатура,
		|	ДвиженияСерийныеНомераИзменение.Характеристика КАК Характеристика,
		|	ДвиженияСерийныеНомераИзменение.Партия КАК Партия,
		|	ДвиженияСерийныеНомераИзменение.СерийныйНомер КАК СерийныйНомер,
		|	ДвиженияСерийныеНомераИзменение.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
		|	ДвиженияСерийныеНомераИзменение.Ячейка КАК Ячейка,
		|	ДвиженияСерийныеНомераИзменение.КоличествоПередЗаписью КАК КоличествоПередЗаписью
		|ПОМЕСТИТЬ ДвиженияСерийныеНомераПередЗаписью
		|ИЗ
		|	ДвиженияСерийныеНомераИзменение КАК ДвиженияСерийныеНомераИзменение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СерийныеНомера.НомерСтроки,
		|	СерийныеНомера.Номенклатура,
		|	СерийныеНомера.Характеристика,
		|	СерийныеНомера.Партия,
		|	СерийныеНомера.СерийныйНомер,
		|	СерийныеНомера.СтруктурнаяЕдиница,
		|	СерийныеНомера.Ячейка,
		|	ВЫБОР
		|		КОГДА СерийныеНомера.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА СерийныеНомера.Количество
		|		ИНАЧЕ -СерийныеНомера.Количество
		|	КОНЕЦ
		|ИЗ
		|	РегистрНакопления.СерийныеНомера КАК СерийныеНомера
		|ГДЕ
		|	СерийныеНомера.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	КонецЕсли;
	
	// Временная таблица "ДвиженияСерийныеНомераИзменение" уничтожается
	// Удаляется информация о ее существовании.
	
	Если СтруктураВременныеТаблицы.Свойство("ДвиженияСерийныеНомераИзменение") Тогда
		
		Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияСерийныеНомераИзменение");
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		СтруктураВременныеТаблицы.Удалить("ДвиженияСерийныеНомераИзменение");
	
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события ПриЗаписи набора записей.
//
Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
		ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу "ДвиженияСерийныеНомераИзменение".
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	МИНИМУМ(ДвиженияСерийныеНомераИзменение.НомерСтроки) КАК НомерСтроки,
	|	ДвиженияСерийныеНомераИзменение.Номенклатура КАК Номенклатура,
	|	ДвиженияСерийныеНомераИзменение.Характеристика КАК Характеристика,
	|	ДвиженияСерийныеНомераИзменение.Партия КАК Партия,
	|	ДвиженияСерийныеНомераИзменение.СерийныйНомер КАК СерийныйНомер,
	|	ДвиженияСерийныеНомераИзменение.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ДвиженияСерийныеНомераИзменение.Ячейка КАК Ячейка,
	|	СУММА(ДвиженияСерийныеНомераИзменение.КоличествоПередЗаписью) КАК КоличествоПередЗаписью,
	|	СУММА(ДвиженияСерийныеНомераИзменение.КоличествоИзменение) КАК КоличествоИзменение,
	|	СУММА(ДвиженияСерийныеНомераИзменение.КоличествоПриЗаписи) КАК КоличествоПриЗаписи
	|ПОМЕСТИТЬ ДвиженияСерийныеНомераИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДвиженияСерийныеНомераПередЗаписью.НомерСтроки КАК НомерСтроки,
	|		ДвиженияСерийныеНомераПередЗаписью.Номенклатура КАК Номенклатура,
	|		ДвиженияСерийныеНомераПередЗаписью.Характеристика КАК Характеристика,
	|		ДвиженияСерийныеНомераПередЗаписью.Партия КАК Партия,
	|		ДвиженияСерийныеНомераПередЗаписью.СерийныйНомер КАК СерийныйНомер,
	|		ДвиженияСерийныеНомераПередЗаписью.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|		ДвиженияСерийныеНомераПередЗаписью.Ячейка КАК Ячейка,
	|		ДвиженияСерийныеНомераПередЗаписью.КоличествоПередЗаписью КАК КоличествоПередЗаписью,
	|		ДвиженияСерийныеНомераПередЗаписью.КоличествоПередЗаписью КАК КоличествоИзменение,
	|		0 КАК КоличествоПриЗаписи
	|	ИЗ
	|		ДвиженияСерийныеНомераПередЗаписью КАК ДвиженияСерийныеНомераПередЗаписью
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияСерийныеНомераПриЗаписи.НомерСтроки,
	|		ДвиженияСерийныеНомераПриЗаписи.Номенклатура,
	|		ДвиженияСерийныеНомераПриЗаписи.Характеристика,
	|		ДвиженияСерийныеНомераПриЗаписи.Партия,
	|		ДвиженияСерийныеНомераПриЗаписи.СерийныйНомер,
	|		ДвиженияСерийныеНомераПриЗаписи.СтруктурнаяЕдиница,
	|		ДвиженияСерийныеНомераПриЗаписи.Ячейка,
	|		0,
	|		ВЫБОР
	|			КОГДА ДвиженияСерийныеНомераПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ДвиженияСерийныеНомераПриЗаписи.Количество
	|			ИНАЧЕ ДвиженияСерийныеНомераПриЗаписи.Количество
	|		КОНЕЦ,
	|		ДвиженияСерийныеНомераПриЗаписи.Количество
	|	ИЗ
	|		РегистрНакопления.СерийныеНомера КАК ДвиженияСерийныеНомераПриЗаписи
	|	ГДЕ
	|		ДвиженияСерийныеНомераПриЗаписи.Регистратор = &Регистратор) КАК ДвиженияСерийныеНомераИзменение
	|
	|СГРУППИРОВАТЬ ПО
	|	ДвиженияСерийныеНомераИзменение.Номенклатура,
	|	ДвиженияСерийныеНомераИзменение.Характеристика,
	|	ДвиженияСерийныеНомераИзменение.Партия,
	|	ДвиженияСерийныеНомераИзменение.СерийныйНомер,
	|	ДвиженияСерийныеНомераИзменение.СтруктурнаяЕдиница,
	|	ДвиженияСерийныеНомераИзменение.Ячейка
	|
	|ИМЕЮЩИЕ
	|	СУММА(ДвиженияСерийныеНомераИзменение.КоличествоИзменение) <> 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Партия,
	|	СерийныйНомер,
	|	СтруктурнаяЕдиница,
	|	Ячейка");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаИзРезультатаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаИзРезультатаЗапроса.Следующий();
	
	// Новые изменения были помещены во временную таблицу "ДвиженияСерийныеНомераИзменение".
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияСерийныеНомераИзменение", ВыборкаИзРезультатаЗапроса.Количество > 0);
	
	// Временная таблица "ДвиженияСерийныеНомераПередЗаписью" уничтожается
	Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияСерийныеНомераПередЗаписью");
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры // ПриЗаписи()

#КонецОбласти

#КонецЕсли