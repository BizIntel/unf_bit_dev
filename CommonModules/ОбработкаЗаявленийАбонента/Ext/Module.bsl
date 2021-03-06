﻿
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обработка заявлений абонента 
//             на подключение электронной подписи в модели сервиса".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Регламентное задание.
Процедура ОбработкаЗаявленийАбонентов(ДокументЗаявление) Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания();
	
	Если ЗначениеЗаполнено(ДокументЗаявление) Тогда
		
		Если ДокументЗаявление.Статус = Перечисления.СтатусыЗаявленияАбонентаСпецоператораСвязи.Отправлено
			И НЕ ДокументЗаявление.ПометкаУдаления
			И ДокументЗаявление.Дата + 2 * 30 * 24 * 60 * 60 > ТекущаяДатаСеанса() Тогда
			
			Если ДокументЗаявление.ЭлектроннаяПодписьВМоделиСервиса Тогда
				ЗаявлениеОбработано = ОбработкаЗаявленийАбонентаВызовСервера.ОбработатьИзменениеСтатусаЗаявленияАбонентаВМоделиСервиса(ДокументЗаявление);
			Иначе
				РезультатОтветаСервера 	= ОбработкаЗаявленийАбонентаВызовСервера.ПолучитьИРазобратьОтветНаЗаявление(ДокументЗаявление,,,Истина);
				ЗаявлениеОбработано 	= РезультатОтветаСервера.Выполнено И РезультатОтветаСервера.СтатусИзменился;
			КонецЕсли;
			
			Если ЗаявлениеОбработано Тогда
				ОбработкаЗаявленийАбонентаВызовСервера.ОтключитьОтслеживаниеИзменениеСтатусаЗаявления(ДокументЗаявление);
			КонецЕсли;
			
		Иначе
			
			ОбработкаЗаявленийАбонентаВызовСервера.ОтключитьОтслеживаниеИзменениеСтатусаЗаявления(ДокументЗаявление);
			
		КонецЕсли;
		
	Иначе
		
		ОбработкаЗаявленийАбонентаВызовСервера.ОтключитьОтслеживаниеИзменениеСтатусаЗаявления(ДокументЗаявление);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ВыгрузитьЗаявлениеАбонентаВМоделиСервиса(Знач ЗаявлениеАбонента) Экспорт
	
	НачатьТранзакцию();
	Попытка
		
		МодульУчетаЗаявленийАбонентаВМоделиСервиса.Добавить(СериализоватьЗаявление(ЗаявлениеАбонента));
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Электронная подпись в модели сервиса.Обработка заявлений.Выгрузка'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, Метаданные.Документы.ЗаявлениеАбонентаСпецоператораСвязи, 
			ЗаявлениеАбонента, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			
		Возврат Ложь;
			
	КонецПопытки;
		
	Возврат Истина;
		
КонецФункции

// Процедура, необходимая срабатывания рег задания по отслеживанию заявлений
// в модели сервиса как элемента очереди заданий.
Процедура ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам) Экспорт
	
	СоответствиеИменПсевдонимам.Вставить(Метаданные.РегламентныеЗадания.ОбработкаЗаявленийАбонента.ИмяМетода);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КлючЗаявленийТребующихНапоминанияПозже() Экспорт

	Возврат "ДокументооборотСКонтролирующимиОрганами_ЗаявленияТребующиеНапоминанияПозже";

КонецФункции

Функция СериализоватьЗаявление(ДанныеЗаявления)
	
	Заявление = Новый Структура;
	
	// -> Subscriber
	Абонент = Новый Структура;
	Абонент.Вставить("Type", ?(ДанныеЗаявления.ПризнакУполномоченногоПредставителя, "УполномоченныйПредставитель", "Налогоплательщик"));
	Абонент.Вставить("ApplicationID", ОбщегоНазначения.ЗначениеРазделителяСеанса());
	
	// -> Organization
	Организация = Новый Структура;
	Организация.Вставить("ShortName",           ДанныеЗаявления.КраткоеНаименование);
	Организация.Вставить("FullName",            ДанныеЗаявления.ПолноеНаименование);
	Организация.Вставить("INN",                 ДанныеЗаявления.ИНН);
	Организация.Вставить("KPP",                 ДанныеЗаявления.КПП);
	Организация.Вставить("OGRN",                ДанныеЗаявления.ОГРН);
	Организация.Вставить("RegNumberPFR",        ДанныеЗаявления.РегНомерПФР);
	Организация.Вставить("RegNumberFSS",        ДанныеЗаявления.РегНомерФСС);
	Организация.Вставить("SeparateSubdivision", ДанныеЗаявления.ПризнакОбособленногоПодразделения);
	Организация.Вставить("LegalAddress",        Адрес(ДанныеЗаявления.АдресЮридический));
	Организация.Вставить("ActualAddress",       Адрес(ДанныеЗаявления.АдресФактический));
	Организация.Вставить("Phone",               ДанныеЗаявления.ТелефонОсновной);
	Организация.Вставить("MobilePhone",         ДанныеЗаявления.ТелефонМобильный);
	Организация.Вставить("MobilePhoneAuth",     ДанныеЗаявления.ТелефонМобильныйДляАвторизации);
	Организация.Вставить("Email",               ДанныеЗаявления.ЭлектроннаяПочта);
	Организация.Вставить("EmailAuth",           ДанныеЗаявления.ЭлектроннаяПочтаАутентификация);
	Организация.Вставить("OptionalPhone",       ДанныеЗаявления.ТелефонДополнительный);
	Организация.Вставить("OptionalNumberFSS",   ДанныеЗаявления.ДополнительныйКодФСС);

	// -> DigitalSignatureOwner
	ВладелецЭП = Новый Структура;
	ВладелецЭП.Вставить("Type",        XMLСтрока(ДанныеЗаявления.ВладелецЭЦПТип));
	ВладелецЭП.Вставить("FirstName",   ДанныеЗаявления.ВладелецЭЦПИмя);
	ВладелецЭП.Вставить("MiddleName",  ДанныеЗаявления.ВладелецЭЦПОтчество);
	ВладелецЭП.Вставить("LastName",    ДанныеЗаявления.ВладелецЭЦПФамилия);
	ВладелецЭП.Вставить("SNILS",       ДанныеЗаявления.ВладелецЭЦПСНИЛС); 
	ВладелецЭП.Вставить("Post",        ДанныеЗаявления.ВладелецЭЦПДолжность);
	ВладелецЭП.Вставить("Subdivision", ДанныеЗаявления.ВладелецЭЦППодразделение);
	
	Если ДанныеЗаявления.ВладелецЭЦППол = Перечисления.ПолФизическогоЛица.Мужской Тогда
		Пол = "1";
	ИначеЕсли ДанныеЗаявления.ВладелецЭЦППол = Перечисления.ПолФизическогоЛица.Женский Тогда
		Пол = "2";
	Иначе
		Пол = "0";
	КонецЕсли;
	ВладелецЭП.Вставить("Sex", Пол);
	ВладелецЭП.Вставить("DateOfBirth", ДанныеЗаявления.ВладелецЭЦПДатаРождения);
	ВладелецЭП.Вставить("PlaceOfBirth", ДанныеЗаявления.ВладелецЭЦПМестоРождения);
	
	Гражданство = ДанныеЗаявления.ВладелецЭЦПГражданство;
	КодАльфа2 = "RU";
	Если ЗначениеЗаполнено(Гражданство) И ЗначениеЗаполнено(Гражданство.КодАльфа2) Тогда
		КодАльфа2 = Гражданство.КодАльфа2;
	КонецЕсли;
	
	ВладелецЭП.Вставить("Nationality", КодАльфа2);
	
	// -> DigitalSignatureOwner -> IdentityDocument
	Документ = Новый Структура;
	Документ.Вставить("Type",       РегламентированнаяОтчетностьПереопределяемый.ПолучитьКодВидаДокументаФизическогоЛица(ДанныеЗаявления.ВладелецЭЦПВидДокумента));
	Документ.Вставить("Serial",     ДанныеЗаявления.ВладелецЭЦПСерияДокумента);
	Документ.Вставить("Number",     ДанныеЗаявления.ВладелецЭЦПНомерДокумента);
	Документ.Вставить("Issuer",     ДанныеЗаявления.ВладелецЭЦПКемВыданДокумент);
	Документ.Вставить("IssueDate",  ДанныеЗаявления.ВладелецЭЦПДатаВыдачиДокумента);
	Документ.Вставить("IssuerCode", ДанныеЗаявления.ВладелецЭЦПКодПодразделения);

	ВладелецЭП.Вставить("IdentityDocument", Документ);
	
	// -> Recipients
	Получатели = Новый Массив;
	
	Для Каждого СтрокаТаблицы Из ДанныеЗаявления.Получатели Цикл
		Получатель = Новый Структура;			
		Если СтрокаТаблицы.ТипПолучателя = Перечисления.ТипыКонтролирующихОрганов.ФНС Тогда
			Получатель.Вставить("Type", XMLСтрока(СтрокаТаблицы.ТипПолучателя));
			Получатель.Вставить("Code", СтрокаТаблицы.КодПолучателя);
			Получатель.Вставить("KPP",  СтрокаТаблицы.КПП);
		ИначеЕсли СтрокаТаблицы.ТипПолучателя = Перечисления.ТипыКонтролирующихОрганов.ФСС Тогда
			Получатель.Вставить("Type", XMLСтрока(СтрокаТаблицы.ТипПолучателя));			
		Иначе
			Получатель = Новый Структура;
			Получатель.Вставить("Type", XMLСтрока(СтрокаТаблицы.ТипПолучателя));
			Получатель.Вставить("Code", СтрокаТаблицы.КодПолучателя);
		КонецЕсли;
		
		Получатели.Добавить(Получатель);
	КонецЦикла;
	
	Если ДанныеЗаявления.ПодатьЗаявкуНаСертификатДляФСРАР Тогда
		Получатель = Новый Структура;
		Получатель.Вставить("Type", XMLСтрока(Перечисления.ТипыКонтролирующихОрганов.ФСРАР));
		Получатель.Вставить("Code", XMLСтрока(ДанныеЗаявления.КодРегионаФСРАР));
		Получатели.Добавить(Получатель);
	КонецЕсли;
	
	Если ДанныеЗаявления.ПодатьЗаявкуНаПодключениеРПН Тогда
		Получатель = Новый Структура;
		Получатель.Вставить("Type", XMLСтрока(Перечисления.ТипыКонтролирующихОрганов.РПН));
		Получатели.Добавить(Получатель);
	КонецЕсли;
	
	Если ДанныеЗаявления.ПодатьЗаявкуНаПодключениеФТС Тогда
		Получатель = Новый Структура;
		Получатель.Вставить("Type", XMLСтрока(Перечисления.ТипыКонтролирующихОрганов.ФТС));
		Получатели.Добавить(Получатель);
	КонецЕсли;
	
	Заявление.Вставить("DigitalSignatureOwner", ВладелецЭП);
	Заявление.Вставить("Organization"         , Организация);	
	Заявление.Вставить("Recipients"           , Получатели);
	Заявление.Вставить("RequestID"            , ДанныеЗаявления.ИдентификаторДокументооборота);
	Заявление.Вставить("Type"                 , XMLСтрока(ДанныеЗаявления.ТипЗаявления));
	Заявление.Вставить("CreateDate"           , ТекущаяДатаСеанса());	
	Заявление.Вставить("CodeProduct1C"        , ДанныеЗаявления.НомерОсновнойПоставки1с);
	Заявление.Вставить("Subscriber"           , Абонент);
	Заявление.Вставить("Version"              , "1.5");
	Если ДанныеЗаявления.ТипЗаявления = Перечисления.ТипыЗаявленияАбонентаСпецоператораСвязи.Изменение Тогда
		Заявление.Вставить("KeyID", ДанныеЗаявления.УчетнаяЗапись.ИдентификаторДокументооборота);
		Заявление.Вставить("AbonentID", ДанныеЗаявления.УчетнаяЗапись.ИдентификаторАбонента);
	КонецЕсли;
	
	ИзменившиесяРеквизиты = Новый Массив;
	Для Каждого ИзменившийсяРеквизит Из ДанныеЗаявления.ИзменившиесяРеквизитыВторичногоЗаявления Цикл
		ИзменившиесяРеквизиты.Добавить(XMLСтрока(ИзменившийсяРеквизит.ИзмененныйРеквизит));		
	КонецЦикла;
	Заявление.Вставить("ChangedAttributes", ИзменившиесяРеквизиты);	
	
	Возврат Заявление;
	
КонецФункции

Функция Адрес(АдресСтрокой)
	
	Если Не ЗначениеЗаполнено(АдресСтрокой) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ЧастиАдреса = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(АдресСтрокой, ",");
	Если ЧастиАдреса.Количество() <> 10 И ЧастиАдреса.Количество() <> 13 Тогда
		ВызватьИсключение(НСтр("ru = 'Неверный формат адреса.'"));
	КонецЕсли;
	
	Address = Новый Структура("Country,Postcode,RegionCode,Region,District,City,Locality,Street,House,Building,Apartment");
	
	Address.Country    = ЧастиАдреса[0];
	Address.Postcode   = ЧастиАдреса[1];
	Address.RegionCode = ЧастиАдреса[2];
	Address.Region     = НазваниеРегионаПоКоду(ЧастиАдреса[2]);
	Address.District   = ЧастиАдреса[3];
	Address.City       = ЧастиАдреса[4];
	Address.Locality   = ЧастиАдреса[5];
	Address.Street     = ЧастиАдреса[6];
	Address.House      = ЧастиАдреса[7];
	Address.Building   = ЧастиАдреса[8];
	Address.Apartment  = ЧастиАдреса[9];

	Возврат Address;
	
КонецФункции

Функция НазваниеРегионаПоКоду(КодРегиона)
	
	Название = РегламентированнаяОтчетностьВызовСервера.ПолучитьНазваниеРегионаПоКоду(КодРегиона);
	
	Если Не ЗначениеЗаполнено(Название) Тогда
		// затем пробуем найти в таблице регионов
		МакетРегионы = Обработки.ОбщиеОбъектыРеглОтчетности.ПолучитьМакет("Регионы");
		нрегАдресРегион = нрег(Название);
		Для Индекс = 1 По МакетРегионы.ВысотаТаблицы Цикл
			ТекущийКодРегиона = СокрЛП(МакетРегионы.Область(Индекс, 2, Индекс, 2).Текст);
			Если ТекущийКодРегиона = КодРегиона Тогда
				Название = СокрЛП(МакетРегионы.Область(Индекс, 1, Индекс, 1).Текст);
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Название;
	
КонецФункции

#КонецОбласти