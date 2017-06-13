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
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ЗаказыНаПроизводство.НаборЗаписей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Регистратор", Отбор.Регистратор.Значение);
	Блокировка.Заблокировать();
	
	Если НЕ СтруктураВременныеТаблицы.Свойство("ДвиженияЗаказыНаПроизводствоИзменение") ИЛИ
		СтруктураВременныеТаблицы.Свойство("ДвиженияЗаказыНаПроизводствоИзменение") И НЕ СтруктураВременныеТаблицы.ДвиженияЗаказыНаПроизводствоИзменение Тогда
		
		// Если временная таблица "ДвиженияЗаказыНаПроизводствоИзменение" не существует или не содержит записей
		// об изменении набора, значит набор записывается первый раз или для набора был выполнен контроль остатков.
		// Текущее состояние набора помещается во временную таблицу "ДвиженияЗаказыНаПроизводствоПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно текущего.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЗаказыНаПроизводство.НомерСтроки КАК НомерСтроки,
		|	ЗаказыНаПроизводство.Организация КАК Организация,
		|	ЗаказыНаПроизводство.ЗаказНаПроизводство КАК ЗаказНаПроизводство,
		|	ЗаказыНаПроизводство.Номенклатура КАК Номенклатура,
		|	ЗаказыНаПроизводство.Характеристика КАК Характеристика,
		|	ВЫБОР
		|		КОГДА ЗаказыНаПроизводство.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА ЗаказыНаПроизводство.Количество
		|		ИНАЧЕ -ЗаказыНаПроизводство.Количество
		|	КОНЕЦ КАК КоличествоПередЗаписью
		|ПОМЕСТИТЬ ДвиженияЗаказыНаПроизводствоПередЗаписью
		|ИЗ
		|	РегистрНакопления.ЗаказыНаПроизводство КАК ЗаказыНаПроизводство
		|ГДЕ
		|	ЗаказыНаПроизводство.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
				
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	Иначе
		
		// Если временная таблица "ДвиженияЗаказыНаПроизводствоИзменение" существует и содержит записи
		// об изменении набора, значит набор записывается не первый раз и для набора не был выполнен контроль остатков.
		// Текущее состояние набора и текущее состояние изменений помещаются во временную таблцу "ДвиженияЗаказыНаПроизводствоПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно первоначального.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДвиженияЗаказыНаПроизводствоИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияЗаказыНаПроизводствоИзменение.Организация КАК Организация,
		|	ДвиженияЗаказыНаПроизводствоИзменение.ЗаказНаПроизводство КАК ЗаказНаПроизводство,
		|	ДвиженияЗаказыНаПроизводствоИзменение.Номенклатура КАК Номенклатура,
		|	ДвиженияЗаказыНаПроизводствоИзменение.Характеристика КАК Характеристика,
		|	ДвиженияЗаказыНаПроизводствоИзменение.КоличествоПередЗаписью КАК КоличествоПередЗаписью
		|ПОМЕСТИТЬ ДвиженияЗаказыНаПроизводствоПередЗаписью
		|ИЗ
		|	ДвиженияЗаказыНаПроизводствоИзменение КАК ДвиженияЗаказыНаПроизводствоИзменение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗаказыНаПроизводство.НомерСтроки,
		|	ЗаказыНаПроизводство.Организация,
		|	ЗаказыНаПроизводство.ЗаказНаПроизводство,
		|	ЗаказыНаПроизводство.Номенклатура,
		|	ЗаказыНаПроизводство.Характеристика,
		|	ВЫБОР
		|		КОГДА ЗаказыНаПроизводство.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА ЗаказыНаПроизводство.Количество
		|		ИНАЧЕ -ЗаказыНаПроизводство.Количество
		|	КОНЕЦ
		|ИЗ
		|	РегистрНакопления.ЗаказыНаПроизводство КАК ЗаказыНаПроизводство
		|ГДЕ
		|	ЗаказыНаПроизводство.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
				
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	КонецЕсли;
	
	// Временная таблица "ДвиженияЗаказыНаПроизводствоИзменение" уничтожается
	// Удаляется информация о ее существовании.
	
	Если СтруктураВременныеТаблицы.Свойство("ДвиженияЗаказыНаПроизводствоИзменение") Тогда
		
		Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияЗаказыНаПроизводствоИзменение");
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		СтруктураВременныеТаблицы.Удалить("ДвиженияЗаказыНаПроизводствоИзменение");
	
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
	// и помещается во временную таблицу "ДвиженияЗаказыНаПроизводствоИзменение".
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	МИНИМУМ(ДвиженияЗаказыНаПроизводствоИзменение.НомерСтроки) КАК НомерСтроки,
	|	ДвиженияЗаказыНаПроизводствоИзменение.Организация КАК Организация,
	|	ДвиженияЗаказыНаПроизводствоИзменение.ЗаказНаПроизводство КАК ЗаказНаПроизводство,
	|	ДвиженияЗаказыНаПроизводствоИзменение.Номенклатура КАК Номенклатура,
	|	ДвиженияЗаказыНаПроизводствоИзменение.Характеристика КАК Характеристика,
	|	СУММА(ДвиженияЗаказыНаПроизводствоИзменение.КоличествоПередЗаписью) КАК КоличествоПередЗаписью,
	|	СУММА(ДвиженияЗаказыНаПроизводствоИзменение.КоличествоИзменение) КАК КоличествоИзменение,
	|	СУММА(ДвиженияЗаказыНаПроизводствоИзменение.КоличествоПриЗаписи) КАК КоличествоПриЗаписи
	|ПОМЕСТИТЬ ДвиженияЗаказыНаПроизводствоИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДвиженияЗаказыНаПроизводствоПередЗаписью.НомерСтроки КАК НомерСтроки,
	|		ДвиженияЗаказыНаПроизводствоПередЗаписью.Организация КАК Организация,
	|		ДвиженияЗаказыНаПроизводствоПередЗаписью.ЗаказНаПроизводство КАК ЗаказНаПроизводство,
	|		ДвиженияЗаказыНаПроизводствоПередЗаписью.Номенклатура КАК Номенклатура,
	|		ДвиженияЗаказыНаПроизводствоПередЗаписью.Характеристика КАК Характеристика,
	|		ДвиженияЗаказыНаПроизводствоПередЗаписью.КоличествоПередЗаписью КАК КоличествоПередЗаписью,
	|		ДвиженияЗаказыНаПроизводствоПередЗаписью.КоличествоПередЗаписью КАК КоличествоИзменение,
	|		0 КАК КоличествоПриЗаписи
	|	ИЗ
	|		ДвиженияЗаказыНаПроизводствоПередЗаписью КАК ДвиженияЗаказыНаПроизводствоПередЗаписью
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияЗаказыНаПроизводствоПриЗаписи.НомерСтроки,
	|		ДвиженияЗаказыНаПроизводствоПриЗаписи.Организация,
	|		ДвиженияЗаказыНаПроизводствоПриЗаписи.ЗаказНаПроизводство,
	|		ДвиженияЗаказыНаПроизводствоПриЗаписи.Номенклатура,
	|		ДвиженияЗаказыНаПроизводствоПриЗаписи.Характеристика,
	|		0,
	|		ВЫБОР
	|			КОГДА ДвиженияЗаказыНаПроизводствоПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ДвиженияЗаказыНаПроизводствоПриЗаписи.Количество
	|			ИНАЧЕ ДвиженияЗаказыНаПроизводствоПриЗаписи.Количество
	|		КОНЕЦ,
	|		ДвиженияЗаказыНаПроизводствоПриЗаписи.Количество
	|	ИЗ
	|		РегистрНакопления.ЗаказыНаПроизводство КАК ДвиженияЗаказыНаПроизводствоПриЗаписи
	|	ГДЕ
	|		ДвиженияЗаказыНаПроизводствоПриЗаписи.Регистратор = &Регистратор) КАК ДвиженияЗаказыНаПроизводствоИзменение
	|
	|СГРУППИРОВАТЬ ПО
	|	ДвиженияЗаказыНаПроизводствоИзменение.Организация,
	|	ДвиженияЗаказыНаПроизводствоИзменение.ЗаказНаПроизводство,
	|	ДвиженияЗаказыНаПроизводствоИзменение.Номенклатура,
	|	ДвиженияЗаказыНаПроизводствоИзменение.Характеристика
	|
	|ИМЕЮЩИЕ
	|	СУММА(ДвиженияЗаказыНаПроизводствоИзменение.КоличествоИзменение) <> 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	ЗаказНаПроизводство,
	|	Номенклатура,
	|	Характеристика");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаИзРезультатаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаИзРезультатаЗапроса.Следующий();
	
	// Новые изменения были помещены во временную таблицу "ДвиженияЗаказыНаПроизводствоИзменение".
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияЗаказыНаПроизводствоИзменение", ВыборкаИзРезультатаЗапроса.Количество > 0);
	
	// Временная таблица "ДвиженияЗаказыНаПроизводствоПередЗаписью" уничтожается
	Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияЗаказыНаПроизводствоПередЗаписью");
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры // ПриЗаписи()

#КонецОбласти

#КонецЕсли