﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура обработчик события ОбработкаПолученияДанныхВыбора.
//
Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("Владелец") Тогда
		
		Если ЗначениеЗаполнено(Параметры.Отбор.Владелец) Тогда
			
			ТипВладелец = Параметры.Отбор.Владелец.ТипНоменклатуры;
			
			Если (ТипВладелец = Перечисления.ТипыНоменклатуры.Операция
				ИЛИ ТипВладелец = Перечисления.ТипыНоменклатуры.ВидРабот
				ИЛИ ТипВладелец = Перечисления.ТипыНоменклатуры.Услуга
				ИЛИ (НЕ Константы.ФункциональнаяОпцияИспользоватьПодсистемуПроизводство.Получить() И ТипВладелец = Перечисления.ТипыНоменклатуры.Запас)
				ИЛИ (НЕ Константы.ФункциональнаяОпцияИспользоватьПодсистемуРаботы.Получить() И ТипВладелец = Перечисления.ТипыНоменклатуры.Работа)) Тогда
			
				Сообщение = Новый СообщениеПользователю();
				ТекстНадписи = НСтр("ru = 'Для номенклатуры типа %ТПНоменклатура% спецификация не указывается!'");
				ТекстНадписи = СтрЗаменить(ТекстНадписи, "%ТПНоменклатура%", ТипВладелец);
				Сообщение.Текст = ТекстНадписи;
				Сообщение.Сообщить();
				Отказ = Истина;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Калькуляция
	Если Параметры.Отбор.Свойство("ЗаказПокупателя") Тогда
		
		ЗаказПокупателя = Параметры.Отбор.ЗаказПокупателя;
		
		Если ЗначениеЗаполнено(ЗаказПокупателя) И ТипЗнч(ЗаказПокупателя)=Тип("ДокументСсылка.ЗаказПокупателя") Тогда
			
			МассивЗначений = Новый Массив;
			МассивЗначений.Добавить(ЗаказПокупателя);
			МассивЗначений.Добавить(Документы.ЗаказПокупателя.ПустаяСсылка());
			Параметры.Отбор.ЗаказПокупателя = Новый ФиксированныйМассив(МассивЗначений);
			
		КонецЕсли; 
		
	КонецЕсли;
	// Конец Калькуляция
	
КонецПроцедуры // ОбработкаПолученияДанныхВыбора()

#КонецОбласти

#Область ЗагрузкаДанныхИзВнешнегоИсточника

Процедура ПоляЗагрузкиДанныхИзВнешнегоИсточника(ТаблицаПолейЗагрузки, НастройкиЗагрузкиДанных) Экспорт
	
	//
	// Для группы полей действует правило: хотя бы одно поле в группе должно быть выбрано в колонках
	//
	
	ОписаниеТиповСтрока25 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(25));
	ОписаниеТиповСтрока100 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(100));
	ОписаниеТиповСтрока150 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(150));
	ОписаниеТиповСтрока200 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(200));
	ОписаниеТиповЧисло15_2 = Новый ОписаниеТипов("Число", , , , Новый КвалификаторыЧисла(15, 2, ДопустимыйЗнак.Неотрицательный));
	ОписаниеТиповЧисло15_3 = Новый ОписаниеТипов("Число", , , , Новый КвалификаторыЧисла(15, 3, ДопустимыйЗнак.Неотрицательный));
	
	ОписаниеТиповКолонка = Новый ОписаниеТипов("ПеречислениеСсылка.ТипыСтрокСоставаСпецификации");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ТипСтрокиСостава", "Тип строки", ОписаниеТиповСтрока25, ОписаниеТиповКолонка);
	
	ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.Номенклатура");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Штрихкод", "Штрихкод", ОписаниеТиповСтрока200, ОписаниеТиповКолонка, "Номенклатура", 1, , Истина);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Артикул", "Артикул", ОписаниеТиповСтрока25, ОписаниеТиповКолонка, "Номенклатура", 2, , Истина);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "НоменклатураНаименование", "Номенклатура (наименование)", ОписаниеТиповСтрока100, ОписаниеТиповКолонка, "Номенклатура", 3, , Истина);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристики") Тогда
		
		ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры");
		ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Характеристика", "Характеристика (наименование)", ОписаниеТиповСтрока150, ОписаниеТиповКолонка);
		
	КонецЕсли;
	
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Количество", "Количество", ОписаниеТиповСтрока25, ОписаниеТиповЧисло15_3, , , Истина);
	
	ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.КлассификаторЕдиницИзмерения, СправочникСсылка.ЕдиницыИзмерения");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ЕдиницаИзмерения", "Ед. изм.", ОписаниеТиповСтрока25, ОписаниеТиповКолонка);
	
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ДоляСтоимости", "Доля стоимости", ОписаниеТиповСтрока25, ОписаниеТиповЧисло15_2);
	
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "КоличествоПродукции", "Количество продукции", ОписаниеТиповСтрока25, ОписаниеТиповЧисло15_3);
	
	ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.Спецификации");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Спецификация", "Спецификация (наименование)", ОписаниеТиповСтрока100, ОписаниеТиповКолонка);
	
КонецПроцедуры

Процедура ПриОпределенииОбразцовЗагрузкиДанных(НастройкиЗагрузкиДанных, УникальныйИдентификатор) Экспорт
	
	Образец_csv = ПолучитьМакет("ОбразецЗагрузкиДанных_csv");
	ОбразецЗагрузкиДанных_csv = ПоместитьВоВременноеХранилище(Образец_csv, УникальныйИдентификатор);
	НастройкиЗагрузкиДанных.Вставить("ОбразецЗагрузкиДанных_csv", ОбразецЗагрузкиДанных_csv);
	
	НастройкиЗагрузкиДанных.Вставить("ОбразецЗагрузкиДанных_mxl", "ОбразецЗагрузкиДанных_mxl");
	
	Образец_xlsx = ПолучитьМакет("ОбразецЗагрузкиДанных_xlsx");
	ОбразецЗагрузкиДанных_xlsx = ПоместитьВоВременноеХранилище(Образец_xlsx, УникальныйИдентификатор);
	НастройкиЗагрузкиДанных.Вставить("ОбразецЗагрузкиДанных_xlsx", ОбразецЗагрузкиДанных_xlsx);
	
КонецПроцедуры

Процедура СопоставитьЗагружаемыеДанныеИзВнешнегоИсточника(ТаблицаСопоставленияДанных, НастройкиЗагрузкиДанных) Экспорт
	
	// ТаблицаСопоставленияДанных - Тип ДанныеФормыКоллекция
	Для каждого СтрокаТаблицыФормы Из ТаблицаСопоставленияДанных Цикл
		
		// Номенклатура по ШтрихКоду, Артикулу, Наименованию
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьНоменклатуру(СтрокаТаблицыФормы.Номенклатура, СтрокаТаблицыФормы.Штрихкод, СтрокаТаблицыФормы.Артикул, СтрокаТаблицыФормы.НоменклатураНаименование);
		
		// ТипСтроки по ТипСтроки.Наименование
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьТипСтроки(СтрокаТаблицыФормы.ТипСтрокиСостава, СтрокаТаблицыФормы.ТипСтрокиСостава_ВходящиеДанные, Перечисления.ТипыСтрокСоставаСпецификации.Материал);
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристики") Тогда
			
			Если ЗначениеЗаполнено(СтрокаТаблицыФормы.Номенклатура) Тогда
				
				// Характеристика по Владельцу и Наименованию
				ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьХарактеристику(СтрокаТаблицыФормы.Характеристика, СтрокаТаблицыФормы.Номенклатура, СтрокаТаблицыФормы.Штрихкод, СтрокаТаблицыФормы.Характеристика_ВходящиеДанные);
				
			КонецЕсли;
			
		КонецЕсли;
		
		// Количество
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.ПреобразоватьСтрокуВЧисло(СтрокаТаблицыФормы.Количество, СтрокаТаблицыФормы.Количество_ВходящиеДанные, 1);
		
		// ЕдиницыИзмерения по Наименованию 
		ЗначениеПоУмолчанию = ?(ЗначениеЗаполнено(СтрокаТаблицыФормы.Номенклатура), СтрокаТаблицыФормы.Номенклатура.ЕдиницаИзмерения, Справочники.КлассификаторЕдиницИзмерения.шт);
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьЕдиницыИзмерения(СтрокаТаблицыФормы.Номенклатура, СтрокаТаблицыФормы.ЕдиницаИзмерения, СтрокаТаблицыФормы.ЕдиницаИзмерения_ВходящиеДанные, ЗначениеПоУмолчанию);
		
		// Доля стоимости
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.ПреобразоватьСтрокуВЧисло(СтрокаТаблицыФормы.ДоляСтоимости, СтрокаТаблицыФормы.ДоляСтоимости_ВходящиеДанные, 1);
		
		// Количество продукции
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.ПреобразоватьСтрокуВЧисло(СтрокаТаблицыФормы.КоличествоПродукции, СтрокаТаблицыФормы.КоличествоПродукции_ВходящиеДанные, 1);
		
		// Спецификации по владельцу, наименованию
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьСпецификацию(СтрокаТаблицыФормы.Спецификация, СтрокаТаблицыФормы.Спецификация_ВходящиеДанные, СтрокаТаблицыФормы.Номенклатура);
		
		ПроверитьКорректностьДанныхВСтрокеТаблицы(СтрокаТаблицыФормы);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьКорректностьДанныхВСтрокеТаблицы(СтрокаТаблицыФормы, ПолноеИмяОбъектаЗаполнения = "") Экспорт
	
	ИмяСлужебногоПоля = ЗагрузкаДанныхИзВнешнегоИсточника.ИмяСлужебногоПоляЗагрузкаВПриложениеВозможна();
	
	СтрокаТаблицыФормы[ИмяСлужебногоПоля] = ЗначениеЗаполнено(СтрокаТаблицыФормы.Номенклатура) 
		И  ЗначениеЗаполнено(СтрокаТаблицыФормы.ТипСтрокиСостава) 
		И СтрокаТаблицыФормы.Количество <> 0;
	
КонецПроцедуры

#КонецОбласти

#Область ВерсионированиеОбъектов

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область ИнтерфейсПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
