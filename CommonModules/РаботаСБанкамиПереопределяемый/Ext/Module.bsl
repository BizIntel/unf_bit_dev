﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Банки".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Включает/отключает показ предупреждений о необходимости обновления классификатора банков.
//
// Параметры:
//  ПоказыватьПредупреждение - Булево.
Процедура ПриОпределенииНеобходимостиПоказаПредупрежденияОбУстаревшемКлассификатореБанков(ПоказыватьПредупреждение) Экспорт
	
КонецПроцедуры

// Обновим банки из классификатора, а также устновим их текущее состояние
// (реквизит РучноеИзменение). Связь ищем по БИК и Коррсчету (только для элементов).
// Обновление производим только для элементов, у которых любой из реквизитов
// не совпадает с аналогичным в классификаторе
//
// Параметры:
//
//  - СписокБанков - Массив - элементов с типом СправочникСсылка.КлассификаторБанковРФ - список банков для обновления,
//                            если список банков пуст, то необходимо проверить все элементы и обновить "измененные
//
//  - ОбластьДанных - Число(1, 0) - область данных, для которой необходимо выполнить обновление
//                                  для локального режима = 0, если область данных не передана, обновление не выполняем
//
Функция ОбновитьБанкиИзКлассификатора(Знач СписокБанков = Неопределено, Знач ОбластьДанных) Экспорт
	
	ОбластьОбработана  = Истина;
	Если ОбластьДанных = Неопределено Тогда
		Возврат ОбластьОбработана;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	КлассификаторБанковРФ.Код КАК Код,
	|	КлассификаторБанковРФ.КоррСчет КАК КоррСчет,
	|	КлассификаторБанковРФ.Наименование,
	|	КлассификаторБанковРФ.Город,
	|	КлассификаторБанковРФ.Адрес,
	|	КлассификаторБанковРФ.Телефоны,
	|	КлассификаторБанковРФ.ЭтоГруппа,
	|	КлассификаторБанковРФ.Родитель.Код,
	|	КлассификаторБанковРФ.Родитель.Наименование,
	|	КлассификаторБанковРФ.ДеятельностьПрекращена
	|ПОМЕСТИТЬ ВТ_ИзмененныеБанки
	|ИЗ
	|	Справочник.КлассификаторБанковРФ КАК КлассификаторБанковРФ
	|ГДЕ
	|	КлассификаторБанковРФ.Ссылка В(&СписокБанков)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Код,
	|	КоррСчет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВложенныйЗапросБанки.Банк КАК Банк,
	|	ВложенныйЗапросБанки.Код КАК Код,
	|	ВложенныйЗапросБанки.КоррСчет КАК КоррСчет,
	|	ВложенныйЗапросБанки.Наименование КАК Наименование,
	|	ВложенныйЗапросБанки.Город КАК Город,
	|	ВложенныйЗапросБанки.Адрес КАК Адрес,
	|	ВложенныйЗапросБанки.Телефоны КАК Телефоны,
	|	ВложенныйЗапросБанки.ЭтоГруппа КАК ЭтоГруппа,
	|	ВложенныйЗапросБанки.РодительКод КАК РодительКод,
	|	ВложенныйЗапросБанки.РодительНаименование КАК РодительНаименование,
	|	ВложенныйЗапросБанки.ДеятельностьПрекращена КАК ДеятельностьПрекращена
	|ПОМЕСТИТЬ ВТ_ИзмененныеЭлементы
	|ИЗ
	|	(ВЫБРАТЬ
	|		Банки.Ссылка КАК Банк,
	|		ВТ_ИзмененныеБанки.Код КАК Код,
	|		ВТ_ИзмененныеБанки.КоррСчет КАК КоррСчет,
	|		ВТ_ИзмененныеБанки.Наименование КАК Наименование,
	|		ВТ_ИзмененныеБанки.Город КАК Город,
	|		ВТ_ИзмененныеБанки.Адрес КАК Адрес,
	|		ВТ_ИзмененныеБанки.Телефоны КАК Телефоны,
	|		ВТ_ИзмененныеБанки.ЭтоГруппа КАК ЭтоГруппа,
	|		ВТ_ИзмененныеБанки.РодительКод КАК РодительКод,
	|		ВТ_ИзмененныеБанки.РодительНаименование КАК РодительНаименование,
	|		ВТ_ИзмененныеБанки.ДеятельностьПрекращена КАК ДеятельностьПрекращена
	|	ИЗ
	|		Справочник.Банки КАК Банки
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ИзмененныеБанки КАК ВТ_ИзмененныеБанки
	|			ПО Банки.Код = ВТ_ИзмененныеБанки.Код
	|				И Банки.КоррСчет = ВТ_ИзмененныеБанки.КоррСчет
	|				И Банки.ЭтоГруппа = ВТ_ИзмененныеБанки.ЭтоГруппа
	|				И Банки.Наименование <> ВТ_ИзмененныеБанки.Наименование
	|				И (Банки.РучноеИзменение = 0)
	|	ГДЕ
	|		НЕ Банки.ЭтоГруппа
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Банки.Ссылка,
	|		ВТ_ИзмененныеБанки.Код,
	|		ВТ_ИзмененныеБанки.КоррСчет,
	|		ВТ_ИзмененныеБанки.Наименование,
	|		ВТ_ИзмененныеБанки.Город,
	|		ВТ_ИзмененныеБанки.Адрес,
	|		ВТ_ИзмененныеБанки.Телефоны,
	|		ВТ_ИзмененныеБанки.ЭтоГруппа,
	|		ВТ_ИзмененныеБанки.РодительКод,
	|		ВТ_ИзмененныеБанки.РодительНаименование,
	|		ВТ_ИзмененныеБанки.ДеятельностьПрекращена
	|	ИЗ
	|		Справочник.Банки КАК Банки
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ИзмененныеБанки КАК ВТ_ИзмененныеБанки
	|			ПО Банки.Код = ВТ_ИзмененныеБанки.Код
	|				И Банки.КоррСчет = ВТ_ИзмененныеБанки.КоррСчет
	|				И Банки.ЭтоГруппа = ВТ_ИзмененныеБанки.ЭтоГруппа
	|				И Банки.Город <> ВТ_ИзмененныеБанки.Город
	|				И (Банки.РучноеИзменение = 0)
	|	ГДЕ
	|		НЕ Банки.ЭтоГруппа
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Банки.Ссылка,
	|		ВТ_ИзмененныеБанки.Код,
	|		ВТ_ИзмененныеБанки.КоррСчет,
	|		ВТ_ИзмененныеБанки.Наименование,
	|		ВТ_ИзмененныеБанки.Город,
	|		ВТ_ИзмененныеБанки.Адрес,
	|		ВТ_ИзмененныеБанки.Телефоны,
	|		ВТ_ИзмененныеБанки.ЭтоГруппа,
	|		ВТ_ИзмененныеБанки.РодительКод,
	|		ВТ_ИзмененныеБанки.РодительНаименование,
	|		ВТ_ИзмененныеБанки.ДеятельностьПрекращена
	|	ИЗ
	|		Справочник.Банки КАК Банки
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ИзмененныеБанки КАК ВТ_ИзмененныеБанки
	|			ПО Банки.Код = ВТ_ИзмененныеБанки.Код
	|				И Банки.КоррСчет = ВТ_ИзмененныеБанки.КоррСчет
	|				И Банки.ЭтоГруппа = ВТ_ИзмененныеБанки.ЭтоГруппа
	|				И Банки.Адрес <> ВТ_ИзмененныеБанки.Адрес
	|				И (Банки.РучноеИзменение = 0)
	|	ГДЕ
	|		НЕ Банки.ЭтоГруппа
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Банки.Ссылка,
	|		ВТ_ИзмененныеБанки.Код,
	|		ВТ_ИзмененныеБанки.КоррСчет,
	|		ВТ_ИзмененныеБанки.Наименование,
	|		ВТ_ИзмененныеБанки.Город,
	|		ВТ_ИзмененныеБанки.Адрес,
	|		ВТ_ИзмененныеБанки.Телефоны,
	|		ВТ_ИзмененныеБанки.ЭтоГруппа,
	|		ВТ_ИзмененныеБанки.РодительКод,
	|		ВТ_ИзмененныеБанки.РодительНаименование,
	|		ВТ_ИзмененныеБанки.ДеятельностьПрекращена
	|	ИЗ
	|		Справочник.Банки КАК Банки
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ИзмененныеБанки КАК ВТ_ИзмененныеБанки
	|			ПО Банки.Код = ВТ_ИзмененныеБанки.Код
	|				И Банки.КоррСчет = ВТ_ИзмененныеБанки.КоррСчет
	|				И Банки.ЭтоГруппа = ВТ_ИзмененныеБанки.ЭтоГруппа
	|				И Банки.Телефоны <> ВТ_ИзмененныеБанки.Телефоны
	|				И (Банки.РучноеИзменение = 0)
	|	ГДЕ
	|		НЕ Банки.ЭтоГруппа
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Банки.Ссылка,
	|		ВТ_ИзмененныеБанки.Код,
	|		ВТ_ИзмененныеБанки.КоррСчет,
	|		ВТ_ИзмененныеБанки.Наименование,
	|		ВТ_ИзмененныеБанки.Город,
	|		ВТ_ИзмененныеБанки.Адрес,
	|		ВТ_ИзмененныеБанки.Телефоны,
	|		ВТ_ИзмененныеБанки.ЭтоГруппа,
	|		ВТ_ИзмененныеБанки.РодительКод,
	|		ВТ_ИзмененныеБанки.РодительНаименование,
	|		ВТ_ИзмененныеБанки.ДеятельностьПрекращена
	|	ИЗ
	|		Справочник.Банки КАК Банки
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ИзмененныеБанки КАК ВТ_ИзмененныеБанки
	|			ПО Банки.Код = ВТ_ИзмененныеБанки.Код
	|				И Банки.КоррСчет = ВТ_ИзмененныеБанки.КоррСчет
	|				И Банки.ЭтоГруппа = ВТ_ИзмененныеБанки.ЭтоГруппа
	|				И Банки.Родитель.Код <> ВТ_ИзмененныеБанки.РодительКод
	|				И (Банки.РучноеИзменение = 0)
	|	ГДЕ
	|		НЕ Банки.ЭтоГруппа
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Банки.Ссылка,
	|		ВТ_ИзмененныеБанки.Код,
	|		ВТ_ИзмененныеБанки.КоррСчет,
	|		ВТ_ИзмененныеБанки.Наименование,
	|		ВТ_ИзмененныеБанки.Город,
	|		ВТ_ИзмененныеБанки.Адрес,
	|		ВТ_ИзмененныеБанки.Телефоны,
	|		ВТ_ИзмененныеБанки.ЭтоГруппа,
	|		ВТ_ИзмененныеБанки.РодительКод,
	|		ВТ_ИзмененныеБанки.РодительНаименование,
	|		ВТ_ИзмененныеБанки.ДеятельностьПрекращена
	|	ИЗ
	|		Справочник.Банки КАК Банки
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ИзмененныеБанки КАК ВТ_ИзмененныеБанки
	|			ПО Банки.Код = ВТ_ИзмененныеБанки.Код
	|				И Банки.КоррСчет = ВТ_ИзмененныеБанки.КоррСчет
	|				И Банки.ЭтоГруппа = ВТ_ИзмененныеБанки.ЭтоГруппа
	|				И (Банки.РучноеИзменение = 2)
	|	ГДЕ
	|		НЕ Банки.ЭтоГруппа) КАК ВложенныйЗапросБанки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ИзмененныеЭлементы.Банк КАК Банк,
	|	ВТ_ИзмененныеЭлементы.Код КАК Код,
	|	ВТ_ИзмененныеЭлементы.КоррСчет КАК КоррСчет,
	|	ВТ_ИзмененныеЭлементы.Наименование КАК Наименование,
	|	ВТ_ИзмененныеЭлементы.Город КАК Город,
	|	ВТ_ИзмененныеЭлементы.Адрес КАК Адрес,
	|	ВТ_ИзмененныеЭлементы.Телефоны КАК Телефоны,
	|	ВТ_ИзмененныеЭлементы.ЭтоГруппа КАК ЭтоГруппа,
	|	0 КАК РучноеИзменение,
	|	ЕСТЬNULL(Банки.Ссылка, ЗНАЧЕНИЕ(Справочник.Банки.ПустаяСсылка)) КАК Родитель,
	|	ВТ_ИзмененныеЭлементы.РодительКод КАК РодительКод,
	|	ВТ_ИзмененныеЭлементы.РодительНаименование КАК РодительНаименование,
	|	ВТ_ИзмененныеЭлементы.ДеятельностьПрекращена КАК ДеятельностьПрекращена
	|ИЗ
	|	ВТ_ИзмененныеЭлементы КАК ВТ_ИзмененныеЭлементы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Банки КАК Банки
	|		ПО ВТ_ИзмененныеЭлементы.РодительКод = Банки.Код
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Банки.Ссылка,
	|	ВТ_ИзмененныеБанки.Код,
	|	NULL,
	|	ВТ_ИзмененныеБанки.Наименование,
	|	NULL,
	|	NULL,
	|	NULL,
	|	ВТ_ИзмененныеБанки.ЭтоГруппа,
	|	0,
	|	NULL,
	|	NULL,
	|	NULL,
	|	ВТ_ИзмененныеБанки.ДеятельностьПрекращена
	|ИЗ
	|	Справочник.Банки КАК Банки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ИзмененныеБанки КАК ВТ_ИзмененныеБанки
	|		ПО Банки.Код = ВТ_ИзмененныеБанки.Код
	|			И Банки.Наименование <> ВТ_ИзмененныеБанки.Наименование
	|			И (Банки.РучноеИзменение = 0)
	|ГДЕ
	|	ВТ_ИзмененныеБанки.ЭтоГруппа
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Банки.Ссылка,
	|	ВТ_ИзмененныеБанки.Код,
	|	NULL,
	|	ВТ_ИзмененныеБанки.Наименование,
	|	NULL,
	|	NULL,
	|	NULL,
	|	ВТ_ИзмененныеБанки.ЭтоГруппа,
	|	0,
	|	NULL,
	|	NULL,
	|	NULL,
	|	ВТ_ИзмененныеБанки.ДеятельностьПрекращена
	|ИЗ
	|	Справочник.Банки КАК Банки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ИзмененныеБанки КАК ВТ_ИзмененныеБанки
	|		ПО Банки.Код = ВТ_ИзмененныеБанки.Код
	|			И (Банки.РучноеИзменение = 2)
	|ГДЕ
	|	ВТ_ИзмененныеБанки.ЭтоГруппа
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЭтоГруппа УБЫВ";
	
	Если СписокБанков = Неопределено ИЛИ СписокБанков.Количество() = 0 Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "
			|ГДЕ
			|	КлассификаторБанковРФ.Ссылка В(&СписокБанков)", "");
	Иначе
		Запрос.УстановитьПараметр("СписокБанков",  СписокБанков);
	КонецЕсли;
	
	Запрос.Текст  = ТекстЗапроса;
	ВыборкаБанков = Запрос.Выполнить().Выбрать();
	
	ИсключаяСвойстваДляЭлемента = "ЭтоГруппа";
	ИсключаяСвойстваДляГруппы   = "Адрес, Город, КоррСчет, Телефоны, Родитель, ЭтоГруппа";
	
	Пока ВыборкаБанков.Следующий() Цикл
		
		Банк = ВыборкаБанков.Банк.ПолучитьОбъект();
		ЗаполнитьЗначенияСвойств(Банк, ВыборкаБанков,,
			?(ВыборкаБанков.ЭтоГруппа, ИсключаяСвойстваДляГруппы, ИсключаяСвойстваДляЭлемента));
		
		Если НЕ ВыборкаБанков.ЭтоГруппа И НЕ ЗначениеЗаполнено(ВыборкаБанков.Родитель) И НЕ ПустаяСтрока(ВыборкаБанков.РодительКод) Тогда
			Родитель = СсылкаНаБанк(ВыборкаБанков.РодительКод, Истина);
			Если НЕ ЗначениеЗаполнено(Родитель) Тогда
				Родитель = Справочники.Банки.СоздатьГруппу();
				Родитель.Код          = ВыборкаБанков.РодительКод;
				Родитель.Наименование = ВыборкаБанков.РодительНаименование;
				
				Попытка
					Родитель.Записать();
				Исключение
					ШаблонСообщения   = НСтр("ru = 'Ошибка при записи банка-группы (региона) %1.
						|%2'");
					ТекстСообщения    = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения,
						ВыборкаБанков.РодительНаименование,
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
					НомерОбласти      = ?(ОбщегоНазначенияПовтИсп.РазделениеВключено(),
						СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = ' в области %1'"), ОбластьДанных),
						"");
					ИмяСобытия        = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Обновление банков%1'"), НомерОбласти);
					ЗаписьЖурналаРегистрации(ИмяСобытия, 
						УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
					
					ОбластьОбработана = Ложь;
					Прервать;
				КонецПопытки
			КонецЕсли;
			
			Банк.Родитель = Родитель.Ссылка;
		КонецЕсли;
		
		Попытка
			Банк.Записать();
		Исключение
			ШаблонСообщения   = НСтр("ru = 'Ошибка при записи банка с БИКом %1
				|%2'");
			ТекстСообщения    = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения,
				ВыборкаБанков.Код,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			НомерОбласти      = ?(ОбщегоНазначенияПовтИсп.РазделениеВключено(),
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = ' в области %1'"), ОбластьДанных),
				"");
			ИмяСобытия        = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Обновление банков%1'"), НомерОбласти);
			ЗаписьЖурналаРегистрации(ИмяСобытия, 
			УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
			
			ОбластьОбработана = Ложь;
		КонецПопытки;
		
	КонецЦикла;
	
	Если НЕ ОбластьОбработана Тогда
		Возврат ОбластьОбработана;
	КонецЕсли;
	
	// Найдем банки которые потеряли связь с классификатором
	// и установим им соотвествующий признак
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Банки.Ссылка КАК Банк,
	|	2 КАК РучноеИзменение
	|ИЗ
	|	Справочник.Банки КАК Банки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторБанковРФ КАК КлассификаторБанковРФ
	|		ПО Банки.Код = КлассификаторБанковРФ.Код
	|			И (Банки.ЭтоГруппа
	|				ИЛИ Банки.КоррСчет = КлассификаторБанковРФ.КоррСчет)
	|ГДЕ
	|	КлассификаторБанковРФ.Ссылка ЕСТЬ NULL 
	|	И Банки.РучноеИзменение <> 2
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	Банки.Ссылка,
	|	3
	|ИЗ
	|	Справочник.Банки КАК Банки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторБанковРФ КАК КлассификаторБанковРФ
	|		ПО Банки.Код = КлассификаторБанковРФ.Код
	|			И (Банки.ЭтоГруппа
	|				ИЛИ Банки.КоррСчет = КлассификаторБанковРФ.КоррСчет)
	|ГДЕ
	|	КлассификаторБанковРФ.ДеятельностьПрекращена
	|	И Банки.РучноеИзменение < 2";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Банк = Выборка.Банк.ПолучитьОбъект();
		Банк.РучноеИзменение = Выборка.РучноеИзменение;
		
		Попытка
			Банк.Записать();
		Исключение
			ШаблонСообщения   = НСтр("ru = 'Ошибка при записи банка с БИКом %1
				|%2'");
			ТекстСообщения    = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения,
				ВыборкаБанков.Код,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			НомерОбласти      = ?(ОбщегоНазначенияПовтИсп.РазделениеВключено(),
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru ' в области %1'"), ОбластьДанных),
				"");
			ИмяСобытия        = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Обновление банков%1'"), НомерОбласти);
			ЗаписьЖурналаРегистрации(ИмяСобытия, 
			УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
			
			ОбластьОбработана = Ложь;
		КонецПопытки;
		
	КонецЦикла;
	
	Возврат ОбластьОбработана;
	
КонецФункции

// Считывает текущее состояние объекта и приводит форму
// в соответстие с ним
//
Процедура СчитатьФлагРучногоИзменения(Знач Форма) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Банки.РучноеИзменение КАК РучноеИзменение
	|ИЗ
	|	Справочник.Банки КАК Банки
	|ГДЕ
	|	Банки.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Форма.Объект.Ссылка);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если РезультатЗапроса.Пустой() Тогда
		
		Форма.РучноеИзменение = Неопределено;
		
	Иначе
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		
		Если Выборка.РучноеИзменение >= 2 Тогда
			Форма.РучноеИзменение = Неопределено;
		Иначе
			Форма.РучноеИзменение = Выборка.РучноеИзменение;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Форма.РучноеИзменение = Неопределено Тогда
		СсылкаНаКлассификатор = СсылкаПоКлассификатору(Форма.Объект.Код);
		Если ЗначениеЗаполнено(СсылкаНаКлассификатор) Тогда
			Запрос.УстановитьПараметр("Ссылка", СсылкаНаКлассификатор);
			Запрос.Текст =
			"ВЫБРАТЬ
			|	КлассификаторБанковРФ.ДеятельностьПрекращена
			|ИЗ
			|	Справочник.КлассификаторБанковРФ КАК КлассификаторБанковРФ
			|ГДЕ
			|	КлассификаторБанковРФ.Ссылка = &Ссылка";
			
			Выборка = Запрос.Выполнить().Выбрать();
			Выборка.Следующий();
			Форма.ДеятельностьПрекращена = Выборка.ДеятельностьПрекращена;
		КонецЕсли;
	КонецЕсли;
	
	ОбработатьФлагРучногоИзменения(Форма);
	
КонецПроцедуры

// Функция осуществляет подбор данных классификатора, для копирования в элемент справочника Банки
// если такого банка ещё нет, то он создается
// если банк находится в иерархии не на первом уровне, то создается/копируется вся цепочка родителей
//
// Параметры:
//
// - СсылкиБанков - Массив с элементами типа СправочникСсылка.КлассификаторБанковРФ - список значений классификатора
//   которые необходимо обработать
// - ИгнорироватьРучноеИзменение - Булево - указание не обрабатывать банки, измененные вручную
//
// Возвращаемое значение:
//
// - Массив с элементами типа СправочникСсылка.Банки
//
Функция ПодобратьБанкИзКлассификатора(Знач СсылкиБанков, ИгнорироватьРучноеИзменение = Ложь) Экспорт
	
	МассивБанков = Новый Массив;
	
	Если СсылкиБанков.Количество() = 0 Тогда
		Возврат МассивБанков;
	КонецЕсли;
	
	СсылкиИерархия = ДополнитьМассивРодителямиСсылок(СсылкиБанков);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СсылкиИерархия", СсылкиИерархия);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КлассификаторБанковРФ.Код КАК БИК,
	|	КлассификаторБанковРФ.КоррСчет КАК КоррСчет,
	|	КлассификаторБанковРФ.Наименование,
	|	КлассификаторБанковРФ.Город,
	|	КлассификаторБанковРФ.Адрес,
	|	КлассификаторБанковРФ.Телефоны,
	|	КлассификаторБанковРФ.ЭтоГруппа,
	|	КлассификаторБанковРФ.Родитель.Код
	|ПОМЕСТИТЬ ВТ_КлассификаторБанковРФ
	|ИЗ
	|	Справочник.КлассификаторБанковРФ КАК КлассификаторБанковРФ
	|ГДЕ
	|	КлассификаторБанковРФ.Ссылка В(&СсылкиИерархия)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	БИК,
	|	КоррСчет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(Банки.Ссылка, ЗНАЧЕНИЕ(Справочник.Банки.ПустаяСсылка)) КАК Банк,
	|	ВТ_КлассификаторБанковРФ.БИК КАК Код,
	|	ВТ_КлассификаторБанковРФ.КоррСчет КАК КоррСчет,
	|	ВТ_КлассификаторБанковРФ.ЭтоГруппа КАК ЭтоРегион,
	|	ВТ_КлассификаторБанковРФ.Наименование,
	|	ВТ_КлассификаторБанковРФ.Город,
	|	ВТ_КлассификаторБанковРФ.Адрес,
	|	ВТ_КлассификаторБанковРФ.Телефоны,
	|	0 КАК РучноеИзменение,
	|	ЕСТЬNULL(ВТ_КлассификаторБанковРФ.РодительКод, """") КАК РодительКод
	|ПОМЕСТИТЬ БанкиБезРодителей
	|ИЗ
	|	ВТ_КлассификаторБанковРФ КАК ВТ_КлассификаторБанковРФ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Банки КАК Банки
	|		ПО ВТ_КлассификаторБанковРФ.КоррСчет = Банки.КоррСчет
	|			И ВТ_КлассификаторБанковРФ.БИК = Банки.Код
	|ГДЕ
	|	НЕ ВТ_КлассификаторБанковРФ.ЭтоГруппа
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЕСТЬNULL(Банки.Ссылка, ЗНАЧЕНИЕ(Справочник.Банки.ПустаяСсылка)),
	|	ВТ_КлассификаторБанковРФ.БИК,
	|	NULL,
	|	ВТ_КлассификаторБанковРФ.ЭтоГруппа,
	|	ВТ_КлассификаторБанковРФ.Наименование,
	|	NULL,
	|	NULL,
	|	NULL,
	|	0,
	|	ЕСТЬNULL(ВТ_КлассификаторБанковРФ.РодительКод, """")
	|ИЗ
	|	ВТ_КлассификаторБанковРФ КАК ВТ_КлассификаторБанковРФ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Банки КАК Банки
	|		ПО ВТ_КлассификаторБанковРФ.БИК = Банки.Код
	|ГДЕ
	|	ВТ_КлассификаторБанковРФ.ЭтоГруппа
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	РодительКод
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	БанкиБезРодителей.Банк,
	|	БанкиБезРодителей.Код КАК Код,
	|	БанкиБезРодителей.КоррСчет,
	|	БанкиБезРодителей.ЭтоРегион КАК ЭтоРегион,
	|	БанкиБезРодителей.Наименование,
	|	БанкиБезРодителей.Город,
	|	БанкиБезРодителей.Адрес,
	|	БанкиБезРодителей.Телефоны,
	|	БанкиБезРодителей.РучноеИзменение,
	|	БанкиБезРодителей.РодительКод,
	|	ЕСТЬNULL(Банки.Ссылка, ЗНАЧЕНИЕ(Справочник.Банки.ПустаяСсылка)) КАК Родитель
	|ИЗ
	|	БанкиБезРодителей КАК БанкиБезРодителей
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Банки КАК Банки
	|		ПО БанкиБезРодителей.РодительКод = Банки.Родитель
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЭтоРегион УБЫВ,
	|	Код";
	
	УстановитьПривилегированныйРежим(Истина);
	ТаблицаБанков = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Ссылки = Новый Массив;
	Для каждого СтрокаТаблицыЗначений Из ТаблицаБанков Цикл
		
		ПараметрыОбъекта = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(СтрокаТаблицыЗначений);
		УдалитьНеВалидныеКлючиСтруктуры(ПараметрыОбъекта);
		Ссылки.Добавить(ПараметрыОбъекта);
		
	КонецЦикла;
	
	МассивБанков = СоздатьОбновитьБанкиВИБ(Ссылки, ИгнорироватьРучноеИзменение);
	
	Возврат МассивБанков;
	
КонецФункции

// Восстановление данных из общего объекта и изменяет
// состояние объекта
//
Процедура ВосстановитьЭлементИзОбщихДанных(Знач Форма) Экспорт
	
	НачатьТранзакцию();
	Попытка
		Ссылки = Новый Массив;
		Классификатор = СсылкаПоКлассификатору(
			Форма.Объект.Код, СокрЛП(Форма.Объект.КоррСчет));
		
		Если НЕ ЗначениеЗаполнено(Классификатор) Тогда
			Возврат;
		КонецЕсли;
		
		Ссылки.Добавить(Классификатор);
		ПодобратьБанкИзКлассификатора(Ссылки, Истина);
		
		Форма.РучноеИзменение = Ложь;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Восстановление из общих данных'"), 
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
	Форма.Прочитать();
	
КонецПроцедуры

// Копирует банки во все ОД
//
// Параметры
//  ТаблицаБанков - ТаблицаЗначений с банками
//  ОбластиДляОбновления - Массив со списком кодов областей
//  ИдентификаторФайла - УникальныйИдентификатор файла обрабатываемых банков
//  КодОбработчика - Строка, код обработчика
//
Процедура РаспространитьБанкиПоОД(Знач СписокБанков, Знач ИдентификаторФайла, Знач КодОбработчика) Экспорт
	
	ОбластиДляОбновления  = ПоставляемыеДанные.ОбластиТребующиеОбработки(
		ИдентификаторФайла, "БанкиРФ");
	
	Для каждого ОбластьДанных Из ОбластиДляОбновления Цикл
		ОбластьОбработана = Ложь;
		УстановитьПривилегированныйРежим(Истина);
		ОбщегоНазначения.УстановитьРазделениеСеанса(Истина, ОбластьДанных);
		УстановитьПривилегированныйРежим(Ложь);
		
		НачатьТранзакцию();
		ОбластьОбработана = РаботаСБанкамиПереопределяемый.ОбновитьБанкиИзКлассификатора(
			СписокБанков, ОбластьДанных);
		
		Если ОбластьОбработана Тогда
			ПоставляемыеДанные.ОбластьОбработана(ИдентификаторФайла, КодОбработчика, ОбластьДанных);
			ЗафиксироватьТранзакцию();
		Иначе
			ОтменитьТранзакцию();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Загружает классификатор банков в модели сервиса из поставляемых данных
//
// Параметры:
//   ПутьКФайлу - Строка - путь к файлу bnk.zip, полученному из поставляемых данных
//
Функция ЗагрузитьПоставляемыйКлассификаторБанков(ПутьКФайлу) Экспорт
	
	Возврат РаботаСБанками.ЗагрузитьДанныеИзФайлаРБК(ПутьКФайлу);
	
КонецФункции

// Возвращает значение параметра ДанныеВыбора по введённому текста.
//
// Параметры:
//  ПараметрПоиска		 - Строка - часть наименования банка или БИК.
// 
// Возвращаемое значение:
//  СписокЗначений - значение, которое затем будет передано в ДанныеВыбора
//  обработчика АвтоПодбор.
//
Функция БанкАвтоПодборДанныеВыбора(ПараметрПоиска) Экспорт
	
	Конструктор = Новый СхемаЗапроса;
	Пакет = Конструктор.ПакетЗапросов[0];
	Пакет.ВыбиратьРазрешенные = Истина;
	Оператор0 = Пакет.Операторы[0];
	Оператор0.Источники.Добавить("Справочник.КлассификаторБанковРФ");
	Оператор0.ВыбираемыеПоля.Добавить("Ссылка");
	Оператор0.ВыбираемыеПоля.Добавить("Код");
	Оператор0.ВыбираемыеПоля.Добавить("КоррСчет");
	Оператор0.ВыбираемыеПоля.Добавить("Наименование");
	Оператор0.ВыбираемыеПоля.Добавить("Город");
	Если СтрДлина(ПараметрПоиска) <= 5 Тогда
		Оператор0.КоличествоПолучаемыхЗаписей = СтрДлина(ПараметрПоиска) * 3;
	КонецЕсли;
	Оператор0.Отбор.Добавить("НЕ ЭтоГруппа");
	Оператор0.Отбор.Добавить("ДеятельностьПрекращена = Ложь");
	Оператор1 = Пакет.Операторы.Добавить(Оператор0);
	Оператор2 = Пакет.Операторы.Добавить(Оператор0);
	
	Оператор0.Отбор.Добавить("Код ПОДОБНО &ПараметрПоиска");
	Оператор1.Отбор.Добавить("КоррСчет ПОДОБНО &ПараметрПоиска");
	Оператор2.Отбор.Добавить("Наименование ПОДОБНО &ПараметрПоиска");
	
	Запрос = Новый Запрос(Конструктор.ПолучитьТекстЗапроса());
	
	Запрос.УстановитьПараметр(
	"ПараметрПоиска",
	СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(
	"%[ПараметрПоиска]%",
	Новый Структура("ПараметрПоиска", ПараметрПоиска)));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Результат = Новый СписокЗначений;
	
	Пока Выборка.Следующий() Цикл
		
		Если Результат.НайтиПоЗначению(Выборка.Ссылка) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Результат.Добавить(
		Выборка.Ссылка,
		ПредставлениеБанка(Выборка));
		
	КонецЦикла;
	
	ДобавитьПредложениеЗагрузкиКлассификатора(Результат);
	
	Возврат Результат;
	
КонецФункции

// Возвращает представление банка в видет форматированной строки
//
// Параметры:
//  ЗаписьКлассификатора - ВыборкаИзРезультатаЗапроса - запись классификатора банков
// 
// Возвращаемое значение:
//  ФорматированнаяСтрока - представление банка
//
Функция ПредставлениеБанка(ЗаписьКлассификатора) Экспорт
	
	Наименование = Новый ФорматированнаяСтрока(
	ЗаписьКлассификатора.Наименование,
	Новый Шрифт(,8,Истина));
	
	Город = Новый ФорматированнаяСтрока(
	ЗаписьКлассификатора.Город,
	Новый Шрифт(,8,,Истина));
	
	БИК = Новый ФорматированнаяСтрока(
	СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("(%1)", ЗаписьКлассификатора.Код),
	Новый Шрифт(,8));
	
	Результат = Новый Массив();
	Результат.Добавить(Наименование);
	Результат.Добавить(" ");
	Результат.Добавить(Город);
	Результат.Добавить(" ");
	Результат.Добавить(БИК);
	
	Возврат Новый ФорматированнаяСтрока(Результат); 
	
КонецФункции

// Создаёт элемент справочника Банки по данным элемента КлассификаторБанков
//
// Параметры:
//  КлассификаторБанков	 - СправочникСсылка.КлассификаторБанковРФ - ссылка
//                     	 на элемент справочника классификатор банков,
//                     	 из которого будет создат элемент справочника Банки
// 
// Возвращаемое значение:
//  СправочникСсылка.Банки
//
Функция БанкИзКлассификатора(КлассификаторБанков) Экспорт
	
	Результат = ПодобратьБанкИзКлассификатора(
	ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
	КлассификаторБанков));
	
	Для Каждого КлючИЗначение Из ОбщегоНазначения.ЗначенияРеквизитовОбъектов(Результат, "ЭтоГруппа") Цикл
		Если Не КлючИЗначение.Значение.ЭтоГруппа Тогда
			Возврат КлючИЗначение.Ключ;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Справочники.Банки.ПустаяСсылка();
	
КонецФункции

// Возвращает ссылку на банк по значению из классификатора.
// Если карточка банка не найдена - возвращается пустая ссылка.
//
// Параметры:
//  КлассификаторБанков	 - СправочникСсылка.КлассификаторБанковРФ - ссылка
//                       на элемент справочника классификатор банков
// 
// Возвращаемое значение:
//  СправочникСсылка.Банки
//
Функция СсылкаНаБанкИзКлассификатора(КлассификаторБанков) Экспорт
	
	ДанныеКлассификатора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(КлассификаторБанков, "Код, ЭтоГруппа");
	Возврат СсылкаНаБанк(ДанныеКлассификатора.Код, ДанныеКлассификатора.ЭтоГруппа);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Задает текст состояние разделнного объекта, устанавливает доступность
// кнопок управления состоянием и флага ТолькоПросмотр формы
//
Процедура ОбработатьФлагРучногоИзменения(Знач Форма)
	
	Элементы  = Форма.Элементы;
	
	Если Форма.РучноеИзменение = Неопределено Тогда
		Если Форма.ДеятельностьПрекращена Тогда
			Форма.ТекстРучногоИзменения = "";
		Иначе
			Форма.ТекстРучногоИзменения = НСтр("ru = 'Элемент создан вручную. Автоматическое обновление не возможно.'");
		КонецЕсли;
		
		Элементы.ОбновитьИзКлассификатора.Доступность = Ложь;
		Элементы.Изменить.Доступность = Ложь;
		Форма.ТолькоПросмотр          = Ложь;
		Элементы.Родитель.Доступность = Истина;
		Элементы.Код.Доступность      = Истина;
		Если НЕ Форма.Объект.ЭтоГруппа Тогда
			Элементы.КоррСчет.Доступность = Истина;
		КонецЕсли;
	ИначеЕсли Форма.РучноеИзменение = Истина Тогда
		Форма.ТекстРучногоИзменения = НСтр("ru = 'Автоматическое обновление элемента отключено.'");
		
		Элементы.ОбновитьИзКлассификатора.Доступность = Истина;
		Элементы.Изменить.Доступность = Ложь;
		Форма.ТолькоПросмотр          = Ложь;
		Элементы.Родитель.Доступность = Ложь;
		Элементы.Код.Доступность      = Ложь;
		Если НЕ Форма.Объект.ЭтоГруппа Тогда
			Элементы.КоррСчет.Доступность = Ложь;
		КонецЕсли;
	Иначе
		Форма.ТекстРучногоИзменения = НСтр("ru = 'Элемент обновляется автоматически.'");
		
		Элементы.ОбновитьИзКлассификатора.Доступность = Ложь;
		Элементы.Изменить.Доступность = Истина;
		Форма.ТолькоПросмотр          = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Добавляет в список ДанныеВыбора предложение загрузить классификатор банков
// в случае его неактуальности и при наличии полномочий.
// При актуальном классификаторе список ДанныеВыбора не изменяется.
//
// Параметры:
//  ДанныеВыбора - СписокЗначений - список значений с данными выбора.
//
Процедура ДобавитьПредложениеЗагрузкиКлассификатора(ДанныеВыбора)
	
	Если РаботаСБанками.КлассификаторАктуален() Тогда
		Возврат;
	КонецЕсли;
	
	// В модели сервиса классификатор обновляется автоматически.
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	// В узле РИБ обновляется автоматически.
	Если ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ() Тогда
		Возврат;
	КонецЕсли;
	
	// Пользователь с необходимыми правами.
	Если Не ПравоДоступа("Изменение", Метаданные.Справочники.КлассификаторБанковРФ) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеВыбора.Добавить(
	"ЗагрузитьКлассификатор",
	НСтр("ru = 'Загрузить классификатор банков...'"),,
	БиблиотекаКартинок.Банк);
	
КонецПроцедуры

// Функция для изменения и запись справочника Банки по переданным параметрам
// если такого банка ещё нет, то он создается
// если банк находится в иерархии не на первом уровне, то создается/копируется вся цепочка родителей
//
// Параметры:
//
// - Ссылки - Массив с элементами типа Структура - Ключи структуры - названия реквизитов справочника,
//   Значения структуры - значения данных реквизитов
// - ИгнорироватьРучноеИзменение - Булево - указание не обрабатывать банки, измененные вручную
//   
// Возвращаемое значение:
//
// - Массив с элементами типа СправочникСсылка.Банки
//
Функция СоздатьОбновитьБанкиВИБ(Ссылки, ИгнорироватьРучноеИзменение)
	
	МассивБанков = Новый Массив;
	
	Для инд = 0 По Ссылки.ВГраница() Цикл
		ПараметрыОбъект = Ссылки[инд];
		Банк = ПараметрыОбъект.Банк;
		
		Если ПараметрыОбъект.РучноеИзменение = 1
			И НЕ ИгнорироватьРучноеИзменение Тогда
			МассивБанков.Добавить(Банк);
			Продолжить;
		КонецЕсли;
		
		Если Банк.Пустая() Тогда
			Если ПараметрыОбъект.ЭтоРегион Тогда
				БанкОбъект = Справочники.Банки.СоздатьГруппу();
			Иначе
				БанкОбъект = Справочники.Банки.СоздатьЭлемент();
			КонецЕсли;
		Иначе
			БанкОбъект = Банк.ПолучитьОбъект();
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(БанкОбъект, ПараметрыОбъект);
		Если НЕ ПустаяСтрока(ПараметрыОбъект.РодительКод) И НЕ ЗначениеЗаполнено(ПараметрыОбъект.Родитель) Тогда
			Регион = СсылкаНаБанк(ПараметрыОбъект.РодительКод, Истина);
			
			Если НЕ ЗначениеЗаполнено(Регион) Тогда
				ПараметрыБанковВышеПоИерархии = Новый Массив;
				ПараметрыБанковВышеПоИерархии.Добавить(СсылкаПоКлассификатору(ПараметрыОбъект.РодительКод));
				
				// Если переданный Родитель не является корневым элементом,
				// то будет возвращен массив всех элементов (групп) выше по иерархии.
				// В начале массива будет корневой элемент иерархии, в конце массива - элемента переданный в параметрах 
				МассивБанковВышеПоИерархии = ПодобратьБанкИзКлассификатора(ПараметрыБанковВышеПоИерархии);
				
				Если МассивБанковВышеПоИерархии.Количество() > 0 Тогда
					// Переданный в параметре элемент (к созданию) в возвращенном Массиве будет всегда на последней позиции
					ПоследнийЭлемент = МассивБанковВышеПоИерархии.ВГраница();
					Регион = МассивБанковВышеПоИерархии[ПоследнийЭлемент];
				КонецЕсли;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Регион) И Регион.ЭтоГруппа Тогда
				БанкОбъект.Родитель = Регион;
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(БанкОбъект.Родитель) Тогда
				ИмяСобытия = ?(ИмяСобытия = "",
					НСтр("ru = 'Подбор из классификатора'"), ИмяСобытия);
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не смогли получить родителя у элемента с БИК %1'"), СокрЛП(ПараметрыОбъект.Код));
				ЗаписьЖурналаРегистрации(ИмяСобытия, 
					УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
				Прервать;
			КонецЕсли;
		КонецЕсли;
		
		НачатьТранзакцию();
		Попытка
			БанкОбъект.Записать();
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			
			ИмяСобытия = ?(ИмяСобытия = "",
				НСтр("ru = 'Подбор из классификатора'"), ИмяСобытия);
			ЗаписьЖурналаРегистрации(ИмяСобытия, 
				УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			Прервать;
		КонецПопытки;
		
		МассивБанков.Добавить(БанкОбъект.Ссылка);
	КонецЦикла;
	
	Возврат МассивБанков;
	
КонецФункции

// Полчучение ссылки на элемент справочника Классификатор банков РФ 
// по текстовому представлению БИК или Коррсчет
//
Функция СсылкаПоКлассификатору(БИК, Коррсчет = "")
	
	Если БИК = "" Тогда
		Возврат Справочники.КлассификаторБанковРФ.ПустаяСсылка();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	КлассификаторБанковРФ.Ссылка
	|ИЗ
	|	Справочник.КлассификаторБанковРФ КАК КлассификаторБанковРФ
	|ГДЕ
	|	КлассификаторБанковРФ.Код = &БИК
	|	И КлассификаторБанковРФ.КоррСчет = &Коррсчет";
	
	Запрос.УстановитьПараметр("БИК", БИК);
	
	Если Коррсчет = "" Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И КлассификаторБанковРФ.КоррСчет = &Коррсчет", "");
	Иначе
		Запрос.УстановитьПараметр("Коррсчет", Коррсчет);
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Результат.Пустой() Тогда
		Возврат Справочники.КлассификаторБанковРФ.ПустаяСсылка();
	КонецЕсли;
	
	Возврат Результат.Выгрузить()[0].Ссылка;
	
КонецФункции // СсылкаПоКлассификатору()

// Полчучение ссылки на элемент справочника Банки
// по текстовому представлению БИК или Коррсчет
//
Функция СсылкаНаБанк(БИК, ЭтоРегион = Ложь)
	
	Если БИК = "" Тогда
		Возврат Справочники.Банки.ПустаяСсылка();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Банки.Ссылка
	|ИЗ
	|	Справочник.Банки КАК Банки
	|ГДЕ
	|	Банки.Код = &БИК
	|	И Банки.ЭтоГруппа = &ЭтоГруппа";
	
	Запрос.УстановитьПараметр("БИК",       БИК);
	Запрос.УстановитьПараметр("ЭтоГруппа", ЭтоРегион);
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Результат.Пустой() Тогда
		Возврат Справочники.Банки.ПустаяСсылка();
	КонецЕсли;
	
	Возврат Результат.Выгрузить()[0].Ссылка;
	
КонецФункции // СсылкаНаБанк()

Функция ДополнитьМассивРодителямиСсылок(Знач Ссылки)
	
	ИмяТаблицы = Ссылки[0].Метаданные().ПолноеИмя();
	
	МассивСсылок = Новый Массив;
	Для каждого Ссылка Из Ссылки Цикл
		МассивСсылок.Добавить(Ссылка);
	КонецЦикла;
	
	ТекущиеСсылки = Ссылки;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.Родитель КАК Ссылка
	|ИЗ
	|	" + ИмяТаблицы + " КАК Таблица
	|ГДЕ
	|	Таблица.Ссылка В (&Ссылки)
	|	И Таблица.Родитель <> ЗНАЧЕНИЕ(" + ИмяТаблицы + ".ПустаяСсылка)";
	
	Пока Истина Цикл
		Запрос.УстановитьПараметр("Ссылки", ТекущиеСсылки);
		Результат = Запрос.Выполнить();
		Если Результат.Пустой() Тогда
			Прервать;
		КонецЕсли;
		
		ТекущиеСсылки = Новый Массив;
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			ТекущиеСсылки.Добавить(Выборка.Ссылка);
			МассивСсылок.Добавить(Выборка.Ссылка);
		КонецЦикла;
	КонецЦикла;
	
	Возврат МассивСсылок;
	
КонецФункции

Процедура УдалитьНеВалидныеКлючиСтруктуры(ПараметрыСтруктураСправочника)
	
	Для каждого КлючИЗначение Из ПараметрыСтруктураСправочника Цикл
		Если КлючИЗначение.Значение = Null ИЛИ КлючИЗначение.Ключ = "ЭтоГруппа" Тогда
			ПараметрыСтруктураСправочника.Удалить(КлючИЗначение.Ключ);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти