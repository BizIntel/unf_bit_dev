﻿
Процедура ДозаполнитьПараметрыОткрытияФормы(ПараметрыОткрытия, ПараметрыНачалаРаботы) Экспорт
	
	ВидыБизнеса = Новый ТаблицаЗначений;
	ВидыБизнеса.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Число"));
	ВидыБизнеса.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка"));
	ВидыБизнеса.Колонки.Добавить("Синонимы", Новый ОписаниеТипов("Строка"));
	
	МакетКлассификаторВидовБизнеса = ПолучитьОбщийМакет("КлассификаторВидовБизнеса").ПолучитьТекст();
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(МакетКлассификаторВидовБизнеса);
	
	Пока ЧтениеXML.Прочитать() Цикл
		
		Если ЧтениеXML.Имя = "biz" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			
			Наименование = ЧтениеXML.ПолучитьАтрибут("name");
			Идентификатор = ЧтениеXML.ПолучитьАтрибут("id");
			
			НоваяСтрока = ВидыБизнеса.Добавить();
			НоваяСтрока.Наименование = Наименование;
			НоваяСтрока.Идентификатор = Число(Идентификатор);
			
		ИначеЕсли ЧтениеXML.Имя = "biz" И ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
			
			Продолжить;
			
		ИначеЕсли ЧтениеXML.Имя = "synonym" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			
			ЧтениеXML.Прочитать();
			НоваяСтрока.Синонимы = НоваяСтрока.Синонимы + " " + ЧтениеXML.Значение;
			
		ИначеЕсли ЧтениеXML.Имя = "synonym" И ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
			
			Продолжить;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ПараметрыОткрытия.Вставить("ВидыБизнесаАдресВХранилище", ПоместитьВоВременноеХранилище(ВидыБизнеса));
	
КонецПроцедуры

Процедура ОбработкаЗакрытияФормыНачалаРаботы(ЗначенияРеквизитов, ПараметрыНачалаРаботы, ОбработкаЗавершена) Экспорт
	
	ПараметрыРаботыКлиента = ПараметрыНачалаРаботы.ПараметрыРаботыКлиента;
	
	ОбновитьПользователя(ЗначенияРеквизитов, ПараметрыРаботыКлиента);
	
	ВыполнитьЗаполнениеПоВидуБизнеса(ЗначенияРеквизитов, ПараметрыРаботыКлиента);
	
	ОбновитьЗаписатьОрганизации(ЗначенияРеквизитов, ПараметрыРаботыКлиента);
	
	ЗафиксироватьОкончаниеПервогоВходаВПрограмму();
	
	ОбработкаЗавершена = Истина;
	
КонецПроцедуры

#Область УНФ

// Дублируем метод из УправлениеКонтактнойИнформацией
Процедура ЗаполнитьРеквизитыТабличнойЧастиДляАдресаЭлектроннойПочты(СтрокаТабличнойЧасти, Источник)
	
	Результат = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(СтрокаТабличнойЧасти.Представление, Ложь);
	
	Если Результат.Количество() > 0 Тогда
		СтрокаТабличнойЧасти.АдресЭП = Результат[0].Адрес;
		
		Поз = СтрНайти(СтрокаТабличнойЧасти.АдресЭП, "@");
		Если Поз <> 0 Тогда
			СтрокаТабличнойЧасти.ДоменноеИмяСервера = Сред(СтрокаТабличнойЧасти.АдресЭП, Поз+1);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Дублируем метод из УправлениеКонтактнойИнформацией
Процедура ЗаполнитьРеквизитыТабличнойЧастиДляВебСтраницы(СтрокаТабличнойЧасти, Источник)
	
	// Умолчания
	СтрокаТабличнойЧасти.ДоменноеИмяСервера = "";
	
	АдресСтраницы = Источник.Состав;
	ПространствоИмен = УправлениеКонтактнойИнформациейКлиентСервер.ПространствоИмен();
	Если АдресСтраницы <> Неопределено И АдресСтраницы.Тип() = ФабрикаXDTO.Тип(ПространствоИмен, "ВебСайт") Тогда
		АдресСтрокой = АдресСтраницы.Значение;
		
		// Удалим протокол
		АдресСервера = Прав(АдресСтрокой, СтрДлина(АдресСтрокой) - СтрНайти(АдресСтрокой, "://") );
		
		Пока Лев(АдресСервера, 1) = "/" Цикл
			
			АдресСервера = Сред(АдресСервера, 2);
			
		КонецЦикла;
		
		Поз = СтрНайти(АдресСервера, "/");
		
		// Удалим путь
		АдресСервера = ?(Поз = 0, АдресСервера, Лев(АдресСервера,  Поз-1));
		
		СтрокаТабличнойЧасти.ДоменноеИмяСервера = АдресСервера;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьПользователя(ЗначенияРеквизитов, ПараметрыРаботыКлиента)
	Перем ПользовательСсылка;
	
	Если НЕ ЗначенияРеквизитов.Свойство("Пользователь", ПользовательСсылка)
		ИЛИ НЕ ЗначениеЗаполнено(ПользовательСсылка) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Если ПараметрыРаботыКлиента.РазделениеВключено Тогда
		
		ПользовательОбъект = ПользовательСсылка.ПолучитьОбъект();
		
	Иначе
		
		ПользовательОбъект = Справочники.Пользователи.СоздатьЭлемент();
		
		// Доступно только в локальном режиме
		ПользовательОбъект.Наименование = ЗначенияРеквизитов.ПользовательИмя;
		
		ОписаниеПользователяИБ = Новый Структура;
		ОписаниеПользователяИБ.Вставить("Действие",					"Записать");
		ОписаниеПользователяИБ.Вставить("Имя",						ЗначенияРеквизитов.ПользовательИмя);
		ОписаниеПользователяИБ.Вставить("ПолноеИмя",				ЗначенияРеквизитов.ПользовательИмя);
		ОписаниеПользователяИБ.Вставить("Пароль", 					ЗначенияРеквизитов.ПользовательПароль);
		ОписаниеПользователяИБ.Вставить("АутентификацияСтандартная",Истина);
		ОписаниеПользователяИБ.Вставить("ПарольУстановлен", 		Истина);
		ОписаниеПользователяИБ.Вставить("ПоказыватьВСпискеВыбора",	Истина);
		
		ДоступныеРоли = Новый Массив;
		ДоступныеРоли.Добавить(Метаданные.Роли.АдминистраторСистемы.Имя);
		ДоступныеРоли.Добавить(Метаданные.Роли.ПолныеПрава.Имя);
		ОписаниеПользователяИБ.Вставить("Роли", ДоступныеРоли);
		
		ПользовательОбъект.ДополнительныеСвойства.Вставить("ОписаниеПользователяИБ", ОписаниеПользователяИБ);
		ПользовательОбъект.ДополнительныеСвойства.Вставить("СозданиеАдминистратора", НСтр("ru = 'Создание первого администратора.'"));
		
		ПользовательОбъект.Служебный = Ложь;
		
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ЗначенияРеквизитов.ПользовательТелефон) Тогда
		
		ВидКИ = Справочники.ВидыКонтактнойИнформации.ТелефонПользователя;
		
		МассивСтрок = ПользовательОбъект.КонтактнаяИнформация.НайтиСтроки(Новый Структура("Вид", ВидКИ));
		
		СтрокаКИ = ?(МассивСтрок.Количество() = 0,ПользовательОбъект.КонтактнаяИнформация.Добавить(), МассивСтрок[0]);
		СтрокаКИ.Вид = ВидКИ;
		СтрокаКИ.ЗначенияПолей = УправлениеКонтактнойИнформациейСлужебныйВызовСервера.КонтактнаяИнформацияXMLПоПредставлению(ЗначенияРеквизитов.ПользовательТелефон, ВидКИ);
		СтрокаКИ.Представление = ЗначенияРеквизитов.ПользовательТелефон;
		СтрокаКИ.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон;
		
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ЗначенияРеквизитов.ПользовательEmail) Тогда
		
		ВидКИ = Справочники.ВидыКонтактнойИнформации.EmailПользователя;
		
		МассивСтрок = ПользовательОбъект.КонтактнаяИнформация.НайтиСтроки(Новый Структура("Вид", ВидКИ));
		
		СтрокаКИ = ?(МассивСтрок.Количество() = 0,ПользовательОбъект.КонтактнаяИнформация.Добавить(), МассивСтрок[0]);
		СтрокаКИ.Вид = ВидКИ;
		СтрокаКИ.ЗначенияПолей = УправлениеКонтактнойИнформациейСлужебныйВызовСервера.КонтактнаяИнформацияXMLПоПредставлению(ЗначенияРеквизитов.ПользовательEmail, ВидКИ);
		СтрокаКИ.Представление = ЗначенияРеквизитов.ПользовательEmail;
		СтрокаКИ.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
		
		ЗаполнитьРеквизитыТабличнойЧастиДляАдресаЭлектроннойПочты(СтрокаКИ, ПользовательОбъект);
		
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ЗначенияРеквизитов.ПользовательСайт) Тогда
		
		ВидКИ = Справочники.ВидыКонтактнойИнформации.СайтПользователя;
		
		МассивСтрок = ПользовательОбъект.КонтактнаяИнформация.НайтиСтроки(Новый Структура("Вид", ВидКИ));
		
		СтрокаКИ = ?(МассивСтрок.Количество() = 0,ПользовательОбъект.КонтактнаяИнформация.Добавить(), МассивСтрок[0]);
		СтрокаКИ.Вид = ВидКИ;
		СтрокаКИ.ЗначенияПолей = УправлениеКонтактнойИнформациейСлужебныйВызовСервера.КонтактнаяИнформацияXMLПоПредставлению(ЗначенияРеквизитов.ПользовательСайт, ВидКИ);
		СтрокаКИ.Представление = ЗначенияРеквизитов.ПользовательСайт;
		СтрокаКИ.Тип = Перечисления.ТипыКонтактнойИнформации.ВебСтраница;
		
		_ОбъектXTDO = УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияИзXML(СтрокаКИ.ЗначенияПолей, ВидКИ);
		ЗаполнитьРеквизитыТабличнойЧастиДляВебСтраницы(СтрокаКИ, _ОбъектXTDO);
		
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ПользовательОбъект, Ложь, Истина);
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

Процедура ВыполнитьЗаполнениеПоВидуБизнеса(ЗначенияРеквизитов, ПараметрыРаботыКлиента)
	
	Попытка
		Константы.ВидБизнесаОрганизации.Установить(ЗначенияРеквизитов.ВидБизнесаОрганизации);
		ЗаполнитьНастройкиПоВидуБизнеса(ЗначенияРеквизитов.ВидБизнесаОрганизации);
	Исключение
	КонецПопытки;
	
КонецПроцедуры

Процедура ОбновитьЗаписатьОрганизации(ЗначенияРеквизитов, ПараметрыРаботыКлиента)
	
	// ЗначенияРеквизитов.Организации.Выгрузить() - в толстом приводит к ошибке
	ТаблицаОрганизаций = Обработки.НачалоРаботыСПрограммой.Создать().Организации.Выгрузить(); 
	
	КоличествоОрганизаций = ЗначенияРеквизитов.Организации.Количество();
	Для Счетчик = 0 По КоличествоОрганизаций - 1 Цикл
		
		ЗаполнитьЗначенияСвойств(ТаблицаОрганизаций.Добавить(), ЗначенияРеквизитов.Организации[Счетчик]);
		
	КонецЦикла;
	
	Если КоличествоОрганизаций > 1 Тогда
		
		Константы.ИспользоватьНесколькоОрганизаций.Установить(Истина);
		Константы.НеИспользоватьНесколькоОрганизаций.Установить(Ложь);
		
	КонецЕсли;
	
	НачатьТранзакцию();
	Для каждого СтрокаОрганизации Из ТаблицаОрганизаций Цикл
		
		ОрганизацияОбъект = СтрокаОрганизации.Ссылка.ПолучитьОбъект();
		
		Если ОрганизацияОбъект = Неопределено Тогда
			
			ОрганизацияОбъект = Справочники.Организации.СоздатьЭлемент();
			ОрганизацияОбъект.УстановитьСсылкуНового(СтрокаОрганизации.Ссылка);
			
			ОрганизацияОбъект.ПроизводственныйКалендарь = УправлениеНебольшойФирмойСервер.ПолучитьКалендарьПоПроизводственномуКалендарюРФ(); 
			ОрганизацияОбъект.СтавкаНДСПоУмолчанию = УправлениеНебольшойФирмойПовтИсп.ПолучитьСтавкуНДС(18);
			
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ОрганизацияОбъект, СтрокаОрганизации);
		
		Если ОрганизацияОбъект.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо Тогда
			
			ОрганизацияОбъект.ИспользуетсяОтчетность = (СтрокаОрганизации.ЕстьУСН ИЛИ СтрокаОрганизации.ЕстьЕНВД);
			
			ФизическоеЛицо = Справочники.ФизическиеЛица.СоздатьЭлемент();
			ФизическоеЛицо.Наименование = СтрокаОрганизации.Фамилия
				+ ?(ПустаяСтрока(СтрокаОрганизации.Имя), "", " " + СтрокаОрганизации.Имя)
				+ ?(ПустаяСтрока(СтрокаОрганизации.Отчество), "", " " + СтрокаОрганизации.Отчество);
			ФизическоеЛицо.Записать();
			
			ОрганизацияОбъект.ФизическоеЛицо = ФизическоеЛицо.Ссылка;
			
			МенеджерЗаписиФизЛица = РегистрыСведений.ФИОФизЛиц.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(МенеджерЗаписиФизЛица, СтрокаОрганизации, "Фамилия, Имя, Отчество");
			МенеджерЗаписиФизЛица.Период = '19800101';
			МенеджерЗаписиФизЛица.ФизЛицо = ФизическоеЛицо.Ссылка;
			МенеджерЗаписиФизЛица.Записать(Истина);
			
			МенеджерЗаписиДокументыФизЛиц = РегистрыСведений.ДокументыФизическихЛиц.СоздатьМенеджерЗаписи();
			МенеджерЗаписиДокументыФизЛиц.Период = '19800101';
			МенеджерЗаписиДокументыФизЛиц.ФизЛицо = ФизическоеЛицо.Ссылка;
			МенеджерЗаписиДокументыФизЛиц.ВидДокумента = Справочники.ВидыДокументовФизическихЛиц.ПаспортРФ;
			МенеджерЗаписиДокументыФизЛиц.ЯвляетсяДокументомУдостоверяющимЛичность = Истина;
			МенеджерЗаписиДокументыФизЛиц.Записать(Истина);
			
		КонецЕсли;
		
		МенеджерЗаписи = РегистрыСведений.СистемыНалогообложенияОрганизаций.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Период = '20000101';
		МенеджерЗаписи.Организация = СтрокаОрганизации.Ссылка;
		МенеджерЗаписи.ПлательщикЕНВД = СтрокаОрганизации.ЕстьЕНВД;
		МенеджерЗаписи.ПрименяетсяПатент = СтрокаОрганизации.ЕстьПатент;
		
		Если СтрокаОрганизации.ЕстьУСН = Истина Тогда
			
			МенеджерЗаписи.СистемаНалогообложения = Перечисления.СистемыНалогообложения.Упрощенная;
			МенеджерЗаписи.ПлательщикУСН = Истина;
			МенеджерЗаписи.ОбъектНалогообложения = СтрокаОрганизации.ВидыОбъектовНалогообложения;
			МенеджерЗаписи.СтавкаНалога = СтрокаОрганизации.СтавкаНалога;
			
		Иначе
			
			МенеджерЗаписи.СистемаНалогообложения = Перечисления.СистемыНалогообложения.Общая;
			МенеджерЗаписи.ПлательщикУСН = Ложь;
			
		КонецЕсли;
		
		Попытка
			
			ОрганизацияОбъект.Записать();
			МенеджерЗаписи.Записать(Истина);
			
		Исключение
			
			ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации("Стартовое окно", УровеньЖурналаРегистрации.Ошибка, Метаданные.Справочники.Организации, ТекстОшибки, );
			
			ВызватьИсключение ОписаниеОшибки();
			
			ОтменитьТранзакцию();
			
		КонецПопытки;
		
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

Процедура ЗафиксироватьОкончаниеПервогоВходаВПрограмму()
	
	Константы.ДатаПервогоВходаВСистему.Установить(ТекущаяДата());
	
КонецПроцедуры

Процедура ЗаполнитьНастройкиПоВидуБизнеса(ВидБизнеса)
	
	МакетНастройки = ПолучитьОбщийМакет("КлассификаторВидовБизнесаНастройки").ПолучитьТекст();
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(МакетНастройки);
	
	НачатьТранзакцию();
	
	Пока ЧтениеXML.Прочитать() Цикл
		
		Если ЧтениеXML.Имя = "biz" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			
			ВидБизнесаТекущий = ЧтениеXML.ПолучитьАтрибут("id");
			Если Число(ВидБизнесаТекущий) <> ВидБизнеса Тогда
				Продолжить;
			КонецЕсли;
			
			Пока Истина Цикл
				
				Если ЧтениеXML.Имя = "biz" И ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
					Прервать;
				КонецЕсли;
				
				Если НРег(ЧтениеXML.Имя) = "value" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
					
					НастройкаТип = ЧтениеXML.ПолучитьАтрибут("type");
					НастройкаОбъект = ЧтениеXML.ПолучитьАтрибут("object");
					НастройкаОбъект = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(НастройкаОбъект);
					
					Если НастройкаТип = "Константы" Тогда
						
						ЧтениеXML.Прочитать();
						НастройкаЗначение = ПрочитатьXML(ЧтениеXML);
						
						Константы[НастройкаОбъект.Имя].Установить(НастройкаЗначение);
						
					КонецЕсли;
					
				Иначе
					
					ЧтениеXML.Прочитать();
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
	ЧтениеXML.Закрыть();
	
КонецПроцедуры

#КонецОбласти