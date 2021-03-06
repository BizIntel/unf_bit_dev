﻿#Область ПрограммныйИнтерфейс

// Возвращается информация о налоговом органе, который относится к адресу
//
// Параметры:
//  ЗначенияПолейАдреса  - Строка - значение полей адреса в формате XML
//
// Возвращаемое значение:
//   Структура   - реквизиты налоговой инспекции. 
//                 Содержание структуры описано в функции НовыйСведенияОНалоговомОргане()
//
Функция НалоговыйОрганПоАдресу(Знач ЗначенияПолейАдреса) Экспорт
	
	СведенияОНалоговомОргане = НовыйСведенияОНалоговомОргане();
	
	ОписаниеОшибки = "";
	Прокси = ПроксиСервиса(ОписаниеОшибки);
	Если Прокси <> Неопределено Тогда
		
		СписокДляПроверки = Прокси.ФабрикаXDTO.Создать(Прокси.ФабрикаXDTO.Тип(ПространствоИмен(), "AddressList"));
		ТипАдреса = Прокси.ФабрикаXDTO.Тип(ПространствоИменАдресаРФ(), "АдресРФ");
		
		АдресДляПроверки = ДесериализацияАдресаXDTO(Прокси, ЗначенияПолейАдреса);
		
		ПроверяемыйАдрес = СписокДляПроверки.Item.Добавить(Прокси.ФабрикаXDTO.Создать(СписокДляПроверки.Item.ВладеющееСвойство.Тип));
		ПроверяемыйАдрес.Address = АдресДляПроверки.Состав.Состав;
		ПроверяемыйАдрес.Levels  = УровниКлассификатораКЛАДР();
		
		КодЯзыка = ТекущийКодЛокализации();
		
		Попытка
			РезультатыПроверки = Прокси.Analyze(СписокДляПроверки, КодЯзыка, Истина, Метаданные.Имя);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Адрес %1:'"), ЗначенияПолейАдреса)
				+ Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
		КонецПопытки;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		ОбработатьОшибкуСервиса(ОписаниеОшибки, СведенияОНалоговомОргане);
		Возврат СведенияОНалоговомОргане;
	КонецЕсли;
	
	Если РезультатыПроверки.Item.Количество()>0 Тогда
		
		РезультатПроверки = РезультатыПроверки.Item[0].Variant;
		ОшибкиПроверки    = РезультатыПроверки.Item[0].Error;
		
		Если ОшибкиПроверки.Количество() > 0 Тогда
			ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Адрес %1: %2'"), ЗначенияПолейАдреса, ОшибкиПроверки[0].Text);
		ИначеЕсли РезультатПроверки.Количество()>0 Тогда
			СведенияОНалоговомОргане.КодНалоговойДляЮридическихЛиц = Формат(РезультатПроверки[0].IFNSUL, "ЧЦ=4; ЧДЦ=; ЧВН=; ЧГ=0");
			СведенияОНалоговомОргане.КодНалоговойДляФизическихЛиц  = Формат(РезультатПроверки[0].IFNSFL, "ЧЦ=4; ЧДЦ=; ЧВН=; ЧГ=0");
			СведенияОНалоговомОргане.КодПоОКАТО                    = Формат(РезультатПроверки[0].OKATO, "ЧЦ=11; ЧДЦ=; ЧВН=; ЧГ=0");
			Если РезультатПроверки[0].OKTMO > 99999999 Тогда
				ФорматнаяСтрокаОКТМО = "ЧЦ=11; ЧДЦ=; ЧВН=; ЧГ=0";
			Иначе
				ФорматнаяСтрокаОКТМО = "ЧЦ=8; ЧДЦ=; ЧВН=; ЧГ=0";
			КонецЕсли;
			СведенияОНалоговомОргане.КодПоОКТМО                    = Формат(РезультатПроверки[0].OKTMO, ФорматнаяСтрокаОКТМО);
		Иначе
			ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Адрес %1: ошибка разбора адреса'"), ЗначенияПолейАдреса);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		ОбработатьОшибкуСервиса(ОписаниеОшибки, СведенияОНалоговомОргане);
	КонецЕсли;
	
	Возврат СведенияОНалоговомОргане;
	
КонецФункции


#КонецОбласти

#Область ОписанияРеквизитов

Функция НовыйСведенияОНалоговомОргане()

	СведенияОНалоговомОргане = Новый Структура;
	
	// Заполняется на основе данных ФИАС
	
	СведенияОНалоговомОргане.Вставить("КодНалоговойДляЮридическихЛиц"); // Строка, 4
	СведенияОНалоговомОргане.Вставить("КодНалоговойДляФизическихЛиц");  // Строка, 4
	СведенияОНалоговомОргане.Вставить("КодПоОКТМО");                    // Строка, 11
	СведенияОНалоговомОргане.Вставить("КодПоОКАТО");                    // Строка, 11
	
	// Служебный реквизит
	СведенияОНалоговомОргане.Вставить("ОписаниеОшибки");              // Строка, 0
	
	Возврат СведенияОНалоговомОргане;

КонецФункции 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция УровниКлассификатораКЛАДР()
	
	Уровни = Новый Массив;
	Уровни.Добавить(1);
	Уровни.Добавить(3);
	Уровни.Добавить(4);
	Уровни.Добавить(6);
	Уровни.Добавить(7);
	
	Возврат Новый ФиксированныйМассив(Уровни);
КонецФункции

Функция ДесериализацияАдресаXDTO(Прокси, Строка)
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(Строка);
	
	Тип = Прокси.ФабрикаXDTO.Тип(ПространствоИмен(), "АдресРФ");
	Результат = Прокси.ФабрикаXDTO.ПрочитатьXML(ЧтениеXML, Тип);
	
	Возврат Результат
КонецФункции

Функция ПроксиСервиса(ОписаниеОшибки)
	
	Прокси = Неопределено;
	ПараметрыАутентификации = ПараметрыАутентификацииВСервисе();
	
	Если ПараметрыАутентификации = Неопределено Тогда
		
		// Служебный текст. Должен быть обработан на клиенте.
		ОписаниеОшибки = "НеУказаныПараметрыАутентификации"; 
		
	Иначе
		
		Попытка
			
			ПереданныеПараметры						= ОбщегоНазначения.ПараметрыПодключенияWSПрокси();
			ПереданныеПараметры.АдресWSDL			= АдресСервиса();
			ПереданныеПараметры.URIПространстваИмен	= ПространствоИмен();
			ПереданныеПараметры.ИмяСервиса			= "AddressSystem";
			ПереданныеПараметры.ИмяТочкиПодключения	= "AddressSystemSoap12";
			ПереданныеПараметры.ИмяПользователя		= ПараметрыАутентификации.login;
			ПереданныеПараметры.Пароль				= ПараметрыАутентификации.password;
			ПереданныеПараметры.Таймаут				= 30;
			
			Прокси = ОбщегоНазначения.СоздатьWSПрокси(ПереданныеПараметры);
			
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
		КонецПопытки; 
		
	КонецЕсли;
	
	Возврат Прокси;
	
КонецФункции

Функция ПараметрыАутентификацииВСервисе()
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Возврат Новый Структура("login,password", 
			"fresh", "fresh");
				
	Иначе
		ДанныеАутентификации = ИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
		Если ДанныеАутентификации <> Неопределено Тогда
			Возврат Новый Структура("login,password", 
				ДанныеАутентификации.Логин, 
				ДанныеАутентификации.Пароль);
		Иначе
			Возврат Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции

Процедура ОбработатьОшибкуСервиса(ОписаниеОшибки, СтруктураРеквизитов)
	
	КодОсновногоЯзыка = ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка(); // Для записи события в журнал регистраации
	
	Если ОписаниеОшибки = "НеУказаныПараметрыАутентификации" Тогда
		ТекстОшибки    = "НеУказаныПараметрыАутентификации"; // Служебный текст. Должен быть обработан на клиенте.
		ОписаниеОшибки = НСтр("ru='Не указаны логин и пароль для доступа к интернет-поддержке'");
		ТекстСобытия   = НСтр("ru='Ошибка доступа'", КодОсновногоЯзыка);
		
	ИначеЕсли Найти(ОписаниеОшибки, """status"":401") > 0 Тогда
		ТекстОшибки  = НСтр("ru='Неверно указаны логин и пароль для доступа к интернет-поддержке'");
		ТекстСобытия = НСтр("ru='Ошибка доступа'", КодОсновногоЯзыка);
		
	Иначе
		ТекстОшибки  = НСтр("ru='Ошибка при работе с сервисом (подробнее см. Журнал регистрации)'");
		ТекстСобытия = НСтр("ru='Ошибка при работе с сервисом'", КодОсновногоЯзыка);
	КонецЕсли;
	
	СтруктураРеквизитов.ОписаниеОшибки = ТекстОшибки;
	
	ИмяСобытия = НСтр("ru = 'Сервис данных ФИАС.'", КодОсновногоЯзыка) + " " + ТекстСобытия;
	ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, , , ОписаниеОшибки);
	
КонецПроцедуры

Функция АдресСервиса()

	Возврат "https://api.orgaddress.1c.ru/orgaddress/v1?wsdl";

КонецФункции

Функция ПространствоИмен()
	
	Возврат "http://www.v8.1c.ru/ssl/AddressSystem";
	
КонецФункции

Функция ПространствоИменАдресаРФ()
	
	Возврат "http://www.v8.1c.ru/ssl/contactinfo";
	
КонецФункции

#КонецОбласти
