﻿////////////////////////////////////////////////////////////////////////////////
// Модуль содержит процедуры и функции интерфейсов взаимодействия БРО
// с другими библиотеками/конфигурациями.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Предназначена для получения сведений об уполномоченном представителе организации в налоговом органе.
// Параметры:
//	 РегистрацияВНалоговомОргане - СправочникСсылка.РегистрацииВНалоговомОргане - должно быть непустым значением.
//	 ДатаПодписи - дата - дата, по состоянию на которую будут читаться данные представителя-физлица.
//
// Возвращаемое значение: 
//   Структура - структура с полями: 
//	   * ТипПодписанта - строка со значениями "1", "2";
//	   * ПредставительЮрЛицо - Булево - признак представителя юр. лица; 
//	   * НаименованиеОрганизацииПредставителя - Строка - наименование организации представителя;
//	   * ДокументПредставителя - Строка - документ представителя;
//	   * Фамилия - Строка - фамилия;
//	   * Имя - Строка - имя;
//	   * Отчество - Строка - отчество;
//	   * ФИОПредставителя - Строка - ФИО представителя.
//
Функция СведенияОПредставителеПоРегистрацииВНалоговомОргане(РегистрацияВНалоговомОргане, ДатаПодписи) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ТипПодписанта", "1");
	Результат.Вставить("ПредставительЮрЛицо", Истина);
	Результат.Вставить("НаименованиеОрганизацииПредставителя", "");
	Результат.Вставить("ДокументПредставителя", "");
	Результат.Вставить("Фамилия", "");
	Результат.Вставить("Имя", "");
	Результат.Вставить("Отчество", "");
	Результат.Вставить("ФИОПредставителя", "");

	Если НЕ ЗначениеЗаполнено(РегистрацияВНалоговомОргане) Тогда
		Возврат Результат;
	КонецЕсли;
	
	ДанныеРегистрации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(РегистрацияВНалоговомОргане, "Представитель, УполномоченноеЛицоПредставителя, ДокументПредставителя");
	
	Если НЕ ЗначениеЗаполнено(ДанныеРегистрации.Представитель) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Представитель = ДанныеРегистрации.Представитель;
	Результат.Вставить("ТипПодписанта", "2");
	
	Если НЕ РегламентированнаяОтчетность.ПредставительЯвляетсяФизЛицом(Представитель) Тогда
		
		ИмяПоля = ?(Представитель.Метаданные().Реквизиты.Найти("НаименованиеПолное") <> Неопределено, "НаименованиеПолное", "Наименование");
		Результат.Вставить("НаименованиеОрганизацииПредставителя", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Представитель, ИмяПоля));
		Результат.Вставить("ФИОПредставителя", СокрЛП(ДанныеРегистрации.УполномоченноеЛицоПредставителя));
		СтрокиФИО = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ДанныеРегистрации.УполномоченноеЛицоПредставителя, " ");
		
		Если СтрокиФИО.Количество() > 0 Тогда
			
			Результат.Фамилия = СокрЛП(СтрокиФИО[0]);
			
			Если СтрокиФИО.Количество() > 1 Тогда
				
				Результат.Имя = СокрЛП(СтрокиФИО[1]);
				
				Если СтрокиФИО.Количество() > 2 Тогда
					
					Для ИндСтроки = 2 По СтрокиФИО.ВГраница() Цикл
						Результат.Отчество = Результат.Отчество + ?(ЗначениеЗаполнено(Результат.Отчество), " ", "") + СтрокиФИО[ИндСтроки]
					КонецЦикла;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		Результат.Вставить("ПредставительЮрЛицо", Ложь);
		ЗаполнитьЗначенияСвойств(Результат, РегламентированнаяОтчетность.ПолучитьФИОФизЛица(Представитель, ДатаПодписи));
		Результат.Вставить("ФИОПредставителя", СокрЛП(СокрЛП(Результат.Фамилия) + " " + СокрЛП(Результат.Имя) + " " + СокрЛП(Результат.Отчество)));
		
	КонецЕсли;
	
	Результат.Вставить("ДокументПредставителя", ДанныеРегистрации.ДокументПредставителя);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти