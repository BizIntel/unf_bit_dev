﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Электронная подпись в модели сервиса".
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

Функция УчетнаяЗапись(Знач Объект) Экспорт
	
	Если ТипЗнч(Объект) = Тип("СправочникСсылка.УчетныеЗаписиДокументооборота") Тогда
		Возврат Объект;
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.Организации") Тогда
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект, "УчетнаяЗаписьОбмена");
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ЦиклыОбмена") Тогда
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект, "УчетнаяЗапись");
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументСсылка.ТранспортноеСообщение") Тогда
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект, "УчетнаяЗапись");
	ИначеЕсли ТипЗнч(Объект) = Тип("ДанныеФормыСтруктура") Тогда
		Возврат Объект.УчетнаяЗапись;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция РеквизитыУчетнойЗаписи(Знач Объект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	УчетнаяЗапись = УчетнаяЗапись(Объект);
	
	Если ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		Реквизиты = "ЭлектроннаяПодписьВМоделиСервиса, ТелефонМобильныйДляАвторизации, ИдентификаторДокументооборота, Ссылка";
		РеквизитыУчетнойЗаписи = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(УчетнаяЗапись, Реквизиты);
		Если ЗначениеЗаполнено(РеквизитыУчетнойЗаписи.ЭлектроннаяПодписьВМоделиСервиса) Тогда
			Возврат РеквизитыУчетнойЗаписи;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Новый Структура("ЭлектроннаяПодписьВМоделиСервиса, ТелефонМобильныйДляАвторизации, ИдентификаторДокументооборота, Ссылка",
		Ложь, "", "", Неопределено);
	
КонецФункции

Функция ЭтоЭлектроннаяПодписьВМоделиСервиса(Знач Объект = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбъектЗначение = Объект;
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.РаботаВМоделиСервиса.ЭлектроннаяПодписьВМоделиСервиса") Тогда
		МодульЭлектроннаяПодписьВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("ЭлектроннаяПодписьВМоделиСервиса");	
		Если МодульЭлектроннаяПодписьВМоделиСервиса.ИспользованиеВозможно() Тогда
			Если ТипЗнч(ОбъектЗначение) = Тип("ДанныеФормыСтруктура") ИЛИ ЗначениеЗаполнено(ОбъектЗначение) Тогда
				УчетнаяЗапись = УчетнаяЗапись(ОбъектЗначение);
				Если ЗначениеЗаполнено(УчетнаяЗапись) Тогда
					Возврат РеквизитыУчетнойЗаписи(УчетнаяЗапись).ЭлектроннаяПодписьВМоделиСервиса;
				Иначе
					Возврат Ложь;
				КонецЕсли;
			Иначе
				Запрос = Новый Запрос;
				Запрос.Текст =
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
				|	Организации.УчетнаяЗаписьОбмена.Ссылка
				|ИЗ
				|	Справочник.Организации КАК Организации
				|ГДЕ
				|	НЕ Организации.ПометкаУдаления
				|	И НЕ Организации.УчетнаяЗаписьОбмена.ПометкаУдаления
				|	И Организации.УчетнаяЗаписьОбмена.ЭлектроннаяПодписьВМоделиСервиса";
				Возврат Не Запрос.Выполнить().Пустой();
			КонецЕсли;
		Иначе
			Возврат Ложь;
		КонецЕсли;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

Функция ИспользованиеВозможно() Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.РаботаВМоделиСервиса.ЭлектроннаяПодписьВМоделиСервиса") Тогда
		МодульЭлектроннаяПодписьВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("ЭлектроннаяПодписьВМоделиСервиса");
		Возврат МодульЭлектроннаяПодписьВМоделиСервиса.ИспользованиеВозможно()
			И ПравоДоступа("Чтение", Метаданные.Документы.ЗаявлениеАбонентаСпецоператораСвязи);
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьСертификатПоОрганизации(Организация) Экспорт
	
	Сертификат = Неопределено;
	УчетнаяЗапись = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.УчетнаяЗаписьОрганизации(Организация);
	Если ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		ОтпечатокСертификатаРуководителя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УчетнаяЗапись, "СертификатРуководителя");
		Сертификат = ХранилищеСертификатов.НайтиСертификат(Новый Структура("Отпечаток", ОтпечатокСертификатаРуководителя));
	КонецЕсли;
	
	Возврат Сертификат;
	
КонецФункции

#КонецОбласти