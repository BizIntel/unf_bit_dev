﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура рассчитывает и записывает график выполнения заказа.
// Дата отгрузки указывается в "Периоде". При фактической отгрузке
// по заказу происходит закрытие графика по ФИФО.
//
Процедура РассчитатьГрафикВыполненияЗаказов()
	
	ТаблицаЗаказов = ДополнительныеСвойства.ТаблицаЗаказов;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивЗаказов", ТаблицаЗаказов.ВыгрузитьКолонку("ЗаказПокупателя"));
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаказыПокупателейОстатки.Организация КАК Организация,
	|	ЗаказыПокупателейОстатки.ЗаказПокупателя КАК ЗаказПокупателя,
	|	ЗаказыПокупателейОстатки.Номенклатура КАК Номенклатура,
	|	ЗаказыПокупателейОстатки.Характеристика КАК Характеристика,
	|	ЗаказыПокупателейОстатки.КоличествоОстаток КАК КоличествоОстаток
	|ПОМЕСТИТЬ ВТ_Остатки
	|ИЗ
	|	РегистрНакопления.ЗаказыПокупателей.Остатки(, ЗаказПокупателя В (&МассивЗаказов)) КАК ЗаказыПокупателейОстатки
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	ЗаказПокупателя,
	|	Номенклатура,
	|	Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА Таблица.ДатаОтгрузки = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА НАЧАЛОПЕРИОДА(Таблица.Период, ДЕНЬ)
	|		ИНАЧЕ НАЧАЛОПЕРИОДА(Таблица.ДатаОтгрузки, ДЕНЬ)
	|	КОНЕЦ КАК Период,
	|	Таблица.Организация КАК Организация,
	|	Таблица.ЗаказПокупателя КАК ЗаказПокупателя,
	|	Таблица.Номенклатура КАК Номенклатура,
	|	Таблица.Характеристика КАК Характеристика,
	|	СУММА(Таблица.Количество) КАК КоличествоПлан
	|ПОМЕСТИТЬ ВТ_ПланДвижения
	|ИЗ
	|	РегистрНакопления.ЗаказыПокупателей КАК Таблица
	|ГДЕ
	|	Таблица.ЗаказПокупателя В(&МассивЗаказов)
	|	И Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|	И Таблица.Количество > 0
	|	И Таблица.Активность
	|
	|СГРУППИРОВАТЬ ПО
	|	ВЫБОР
	|		КОГДА Таблица.ДатаОтгрузки = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА НАЧАЛОПЕРИОДА(Таблица.Период, ДЕНЬ)
	|		ИНАЧЕ НАЧАЛОПЕРИОДА(Таблица.ДатаОтгрузки, ДЕНЬ)
	|	КОНЕЦ,
	|	Таблица.Организация,
	|	Таблица.ЗаказПокупателя,
	|	Таблица.Номенклатура,
	|	Таблица.Характеристика
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	ЗаказПокупателя,
	|	Номенклатура,
	|	Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Таблица.Период КАК Период,
	|	ВТ_Таблица.Организация КАК Организация,
	|	ВТ_Таблица.ЗаказПокупателя КАК ЗаказПокупателя,
	|	ВТ_Таблица.Номенклатура КАК Номенклатура,
	|	ВТ_Таблица.Характеристика КАК Характеристика,
	|	ВТ_Таблица.КоличествоПлан КАК КоличествоПлан,
	|	ЕСТЬNULL(ВТ_Остатки.КоличествоОстаток, 0) КАК КоличествоОстаток
	|ИЗ
	|	ВТ_ПланДвижения КАК ВТ_Таблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Остатки КАК ВТ_Остатки
	|		ПО ВТ_Таблица.Организация = ВТ_Остатки.Организация
	|			И ВТ_Таблица.ЗаказПокупателя = ВТ_Остатки.ЗаказПокупателя
	|			И ВТ_Таблица.Номенклатура = ВТ_Остатки.Номенклатура
	|			И ВТ_Таблица.Характеристика = ВТ_Остатки.Характеристика
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗаказПокупателя,
	|	Номенклатура,
	|	Характеристика,
	|	Период УБЫВ";
	
	НаборЗаписей = РегистрыСведений.ГрафикВыполненияЗаказов.СоздатьНаборЗаписей();
	Выборка = Запрос.Выполнить().Выбрать();
	ЕстьЗаписиВВыборке = Выборка.Следующий();
	Пока ЕстьЗаписиВВыборке Цикл
		
		ТекПериод = Неопределено;
		ТекОрганизация = Неопределено;
		ТекНоменклатура = Неопределено;
		ТекХарактеристика = Неопределено;
		ТекЗаказПокупателя = Выборка.ЗаказПокупателя;
		
		НаборЗаписей.Отбор.Заказ.Установить(ТекЗаказПокупателя);
		
		// Из таблицы удаляем отработанный заказ.
		ТаблицаЗаказов.Удалить(ТаблицаЗаказов.Найти(ТекЗаказПокупателя, "ЗаказПокупателя"));
		
		// Цикл по строкам одного заказа.
		ВсегоПлан = 0;
		ВсегоОстаток = 0;
		СтруктураНаборЗаписей = Новый Структура;
		Пока ЕстьЗаписиВВыборке И Выборка.ЗаказПокупателя = ТекЗаказПокупателя Цикл
			
			ВсегоПлан = ВсегоПлан + Выборка.КоличествоПлан;
			
			Если ТекНоменклатура <> Выборка.Номенклатура
				ИЛИ ТекХарактеристика <> Выборка.Характеристика
				ИЛИ ТекОрганизация <> Выборка.Организация Тогда
				
				ТекНоменклатура = Выборка.Номенклатура;
				ТекХарактеристика = Выборка.Характеристика;
				ТекОрганизация = Выборка.Организация;
				
				ВсегоКоличествоОстаток = 0;
				Если Выборка.КоличествоОстаток > 0 Тогда
					ВсегоКоличествоОстаток = Выборка.КоличествоОстаток;
				КонецЕсли;
				
				ВсегоОстаток = ВсегоОстаток + Выборка.КоличествоОстаток;
				
			КонецЕсли;
			
			ТекКоличество = Мин(Выборка.КоличествоПлан, ВсегоКоличествоОстаток);
			Если ТекКоличество > 0 И ?(ЗначениеЗаполнено(ТекПериод), ТекПериод > Выборка.Период, Истина) Тогда
				
				СтруктураНаборЗаписей.Вставить("Период", Выборка.Период);
				СтруктураНаборЗаписей.Вставить("ЗаказПокупателя", Выборка.ЗаказПокупателя);
				
				ТекПериод = Выборка.Период;
				
			КонецЕсли;
			
			ВсегоКоличествоОстаток = ВсегоКоличествоОстаток - ТекКоличество;
			
			// Переход к следующей записи в выборке.
			ЕстьЗаписиВВыборке = Выборка.Следующий();
			
		КонецЦикла;
		
		// Запись и очистка набора.
		Если СтруктураНаборЗаписей.Количество() > 0 Тогда
			Запись = НаборЗаписей.Добавить();
			Запись.Период = СтруктураНаборЗаписей.Период;
			Запись.Заказ = СтруктураНаборЗаписей.ЗаказПокупателя;
			Запись.Выполнено = ВсегоПлан - ВсегоОстаток;
		КонецЕсли;
		
		НаборЗаписей.Записать(Истина);
		НаборЗаписей.Очистить();
		
	КонецЦикла;
	
	// По неотработанным заказам нужно очистить движения.
	Если ТаблицаЗаказов.Количество() > 0 Тогда
		Для Каждого СтрокаТаб Из ТаблицаЗаказов Цикл
			
			НаборЗаписей.Отбор.Заказ.Установить(СтрокаТаб.ЗаказПокупателя);
			НаборЗаписей.Записать(Истина);
			НаборЗаписей.Очистить();
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры // РассчитатьГрафикВыполненияЗаказов()

// Процедура формирует таблицу заказов, которые были раньше в движениях
// и которые сейчас будут записаны.
//
Процедура СФормироватьТаблицуЗаказов()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаЗаказыПокупателей.ЗаказПокупателя КАК ЗаказПокупателя
	|ИЗ
	|	РегистрНакопления.ЗаказыПокупателей КАК ТаблицаЗаказыПокупателей
	|ГДЕ
	|	ТаблицаЗаказыПокупателей.Регистратор = &Регистратор";
	
	ТаблицаЗаказов = Запрос.Выполнить().Выгрузить();
	ТаблицаНовыхЗаказов = Выгрузить(, "ЗаказПокупателя");
	ТаблицаНовыхЗаказов.Свернуть("ЗаказПокупателя");
	Для Каждого Запись Из ТаблицаНовыхЗаказов Цикл
		
		Если ТаблицаЗаказов.Найти(Запись.ЗаказПокупателя, "ЗаказПокупателя") = Неопределено Тогда
			ТаблицаЗаказов.Добавить().ЗаказПокупателя = Запись.ЗаказПокупателя;
		КонецЕсли;
		
	КонецЦикла;
	
	ДополнительныеСвойства.Вставить("ТаблицаЗаказов", ТаблицаЗаказов);
	
КонецПроцедуры // СФормироватьТаблицуЗаказов()

// Процедура устанавливает блокировку данных для расчета графика.
//
Процедура УстановитьБлокировкиДанныхДляРасчетаГрафика()
	
	Блокировка = Новый БлокировкаДанных;
	
	// Блокировка регистра для подсчета остатков по заказам.
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ЗаказыПокупателей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
	ЭлементБлокировки.ИсточникДанных = ДополнительныеСвойства.ТаблицаЗаказов;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ЗаказПокупателя", "ЗаказПокупателя");
	
	// Блокировка набора для записи.
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ГрафикВыполненияЗаказов");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = ДополнительныеСвойства.ТаблицаЗаказов;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Заказ", "ЗаказПокупателя");
	
	Блокировка.Заблокировать();
	
КонецПроцедуры // УстановитьБлокировкиДанныхДляРасчетаГрафика()

// Процедура формирует таблицу исходных движений по регистру.
//
Процедура СформироватьТаблицуИсходныхДвижений(Отказ, Замещение)
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Установка исключительной блокировки текущего набора записей регистратора.
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ЗаказыПокупателей.НаборЗаписей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Регистратор", Отбор.Регистратор.Значение);
	Блокировка.Заблокировать();
	
	Если НЕ СтруктураВременныеТаблицы.Свойство("ДвиженияЗаказыПокупателейИзменение") ИЛИ
		СтруктураВременныеТаблицы.Свойство("ДвиженияЗаказыПокупателейИзменение") И НЕ СтруктураВременныеТаблицы.ДвиженияЗаказыПокупателейИзменение Тогда
		
		// Если временная таблица "ДвиженияЗаказыПокупателейИзменение" не существует или не содержит записей
		// об изменении набора, значит набор записывается первый раз или для набора был выполнен контроль остатков.
		// Текущее состояние набора помещается во временную таблицу "ДвиженияЗаказыПокупателейПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно текущего.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЗаказыПокупателей.НомерСтроки КАК НомерСтроки,
		|	ЗаказыПокупателей.Организация КАК Организация,
		|	ЗаказыПокупателей.ЗаказПокупателя КАК ЗаказПокупателя,
		|	ЗаказыПокупателей.Номенклатура КАК Номенклатура,
		|	ЗаказыПокупателей.Характеристика КАК Характеристика,
		|	ВЫБОР
		|		КОГДА ЗаказыПокупателей.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА ЗаказыПокупателей.Количество
		|		ИНАЧЕ -ЗаказыПокупателей.Количество
		|	КОНЕЦ КАК КоличествоПередЗаписью
		|ПОМЕСТИТЬ ДвиженияЗаказыПокупателейПередЗаписью
		|ИЗ
		|	РегистрНакопления.ЗаказыПокупателей КАК ЗаказыПокупателей
		|ГДЕ
		|	ЗаказыПокупателей.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	Иначе
		
		// Если временная таблица "ДвиженияЗаказыПокупателейИзменение" существует и содержит записи
		// об изменении набора, значит набор записывается не первый раз и для набора не был выполнен контроль остатков.
		// Текущее состояние набора и текущее состояние изменений помещаются во временную таблцу "ДвиженияЗаказыПокупателейПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно первоначального.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДвиженияЗаказыПокупателейИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияЗаказыПокупателейИзменение.Организация КАК Организация,
		|	ДвиженияЗаказыПокупателейИзменение.ЗаказПокупателя КАК ЗаказПокупателя,
		|	ДвиженияЗаказыПокупателейИзменение.Номенклатура КАК Номенклатура,
		|	ДвиженияЗаказыПокупателейИзменение.Характеристика КАК Характеристика,
		|	ДвиженияЗаказыПокупателейИзменение.КоличествоПередЗаписью КАК КоличествоПередЗаписью
		|ПОМЕСТИТЬ ДвиженияЗаказыПокупателейПередЗаписью
		|ИЗ
		|	ДвиженияЗаказыПокупателейИзменение КАК ДвиженияЗаказыПокупателейИзменение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗаказыПокупателей.НомерСтроки,
		|	ЗаказыПокупателей.Организация,
		|	ЗаказыПокупателей.ЗаказПокупателя,
		|	ЗаказыПокупателей.Номенклатура,
		|	ЗаказыПокупателей.Характеристика,
		|	ВЫБОР
		|		КОГДА ЗаказыПокупателей.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА ЗаказыПокупателей.Количество
		|		ИНАЧЕ -ЗаказыПокупателей.Количество
		|	КОНЕЦ
		|ИЗ
		|	РегистрНакопления.ЗаказыПокупателей КАК ЗаказыПокупателей
		|ГДЕ
		|	ЗаказыПокупателей.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	КонецЕсли;
	
	// Временная таблица "ДвиженияЗаказыПокупателейИзменение" уничтожается
	// Удаляется информация о ее существовании.
	
	Если СтруктураВременныеТаблицы.Свойство("ДвиженияЗаказыПокупателейИзменение") Тогда
		
		Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияЗаказыПокупателейИзменение");
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		СтруктураВременныеТаблицы.Удалить("ДвиженияЗаказыПокупателейИзменение");
		
	КонецЕсли;
	
КонецПроцедуры // СформироватьТаблицуИсходныхДвижений()

// Процедура формирует таблицу изменений движений по регистру.
//
Процедура СформироватьТаблицуИзмененийДвижений(Отказ, Замещение)
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу "ДвиженияЗаказыПокупателейИзменение".
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	МИНИМУМ(ДвиженияЗаказыПокупателейИзменение.НомерСтроки) КАК НомерСтроки,
	|	ДвиженияЗаказыПокупателейИзменение.Организация КАК Организация,
	|	ДвиженияЗаказыПокупателейИзменение.ЗаказПокупателя КАК ЗаказПокупателя,
	|	ДвиженияЗаказыПокупателейИзменение.Номенклатура КАК Номенклатура,
	|	ДвиженияЗаказыПокупателейИзменение.Характеристика КАК Характеристика,
	|	СУММА(ДвиженияЗаказыПокупателейИзменение.КоличествоПередЗаписью) КАК КоличествоПередЗаписью,
	|	СУММА(ДвиженияЗаказыПокупателейИзменение.КоличествоИзменение) КАК КоличествоИзменение,
	|	СУММА(ДвиженияЗаказыПокупателейИзменение.КоличествоПриЗаписи) КАК КоличествоПриЗаписи
	|ПОМЕСТИТЬ ДвиженияЗаказыПокупателейИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДвиженияЗаказыПокупателейПередЗаписью.НомерСтроки КАК НомерСтроки,
	|		ДвиженияЗаказыПокупателейПередЗаписью.Организация КАК Организация,
	|		ДвиженияЗаказыПокупателейПередЗаписью.ЗаказПокупателя КАК ЗаказПокупателя,
	|		ДвиженияЗаказыПокупателейПередЗаписью.Номенклатура КАК Номенклатура,
	|		ДвиженияЗаказыПокупателейПередЗаписью.Характеристика КАК Характеристика,
	|		ДвиженияЗаказыПокупателейПередЗаписью.КоличествоПередЗаписью КАК КоличествоПередЗаписью,
	|		ДвиженияЗаказыПокупателейПередЗаписью.КоличествоПередЗаписью КАК КоличествоИзменение,
	|		0 КАК КоличествоПриЗаписи
	|	ИЗ
	|		ДвиженияЗаказыПокупателейПередЗаписью КАК ДвиженияЗаказыПокупателейПередЗаписью
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияЗаказыПокупателейПриЗаписи.НомерСтроки,
	|		ДвиженияЗаказыПокупателейПриЗаписи.Организация,
	|		ДвиженияЗаказыПокупателейПриЗаписи.ЗаказПокупателя,
	|		ДвиженияЗаказыПокупателейПриЗаписи.Номенклатура,
	|		ДвиженияЗаказыПокупателейПриЗаписи.Характеристика,
	|		0,
	|		ВЫБОР
	|			КОГДА ДвиженияЗаказыПокупателейПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ДвиженияЗаказыПокупателейПриЗаписи.Количество
	|			ИНАЧЕ ДвиженияЗаказыПокупателейПриЗаписи.Количество
	|		КОНЕЦ,
	|		ДвиженияЗаказыПокупателейПриЗаписи.Количество
	|	ИЗ
	|		РегистрНакопления.ЗаказыПокупателей КАК ДвиженияЗаказыПокупателейПриЗаписи
	|	ГДЕ
	|		ДвиженияЗаказыПокупателейПриЗаписи.Регистратор = &Регистратор) КАК ДвиженияЗаказыПокупателейИзменение
	|
	|СГРУППИРОВАТЬ ПО
	|	ДвиженияЗаказыПокупателейИзменение.Организация,
	|	ДвиженияЗаказыПокупателейИзменение.ЗаказПокупателя,
	|	ДвиженияЗаказыПокупателейИзменение.Номенклатура,
	|	ДвиженияЗаказыПокупателейИзменение.Характеристика
	|
	|ИМЕЮЩИЕ
	|	СУММА(ДвиженияЗаказыПокупателейИзменение.КоличествоИзменение) <> 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	ЗаказПокупателя,
	|	Номенклатура,
	|	Характеристика");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаИзРезультатаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаИзРезультатаЗапроса.Следующий();
	
	// Новые изменения были помещены во временную таблицу "ДвиженияЗаказыПокупателейИзменение".
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияЗаказыПокупателейИзменение", ВыборкаИзРезультатаЗапроса.Количество > 0);
	
	// Временная таблица "ДвиженияЗапасыНаСкладахПередЗаписью" уничтожается
	Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияЗаказыПокупателейПередЗаписью");
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры // СформироватьТаблицуИзмененийДвижений()

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ПередЗаписью набора записей.
//
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
		ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СформироватьТаблицуИсходныхДвижений(Отказ, Замещение);
	
	СФормироватьТаблицуЗаказов();
	УстановитьБлокировкиДанныхДляРасчетаГрафика();
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события ПриЗаписи набора записей.
//
Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
		ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СформироватьТаблицуИзмененийДвижений(Отказ, Замещение);
	
	РассчитатьГрафикВыполненияЗаказов();
	
КонецПроцедуры // ПриЗаписи()

#КонецОбласти

#КонецЕсли