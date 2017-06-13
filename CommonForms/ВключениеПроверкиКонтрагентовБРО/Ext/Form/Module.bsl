﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоЗапускПроверкиКомандой			= Параметры.Свойство("ЭтоЗапускПроверкиКомандой");
	ЭтоЗапускПроверкиПослеЗаполнения	= Параметры.Свойство("ЭтоЗапускПроверкиПослеЗаполнения");
	ЭтоЗапускПроверкиПриОткрытии		= Параметры.Свойство("ЭтоЗапускПроверкиПриОткрытии");
	
	ЕстьПравоНаРедактированиеНастроекСервиса 	= ПроверкаКонтрагентовБРО.ЕстьПравоНаРедактированиеНастроек();
	
	УправлениеЭУ();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВключитьСервисСейчас(Команда)
	
	ВключитьСервисСейчасСервер();
	Закрыть(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура НапомнитьПозже(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура БольшеНеПоказывать(Команда)
	
	ЗапомнитьЧтоБольшеНеНужноПоказывать();
	Закрыть(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеЭУ()
	
	// В зависимости от наличия административных прав будут доступны разные элементы управления
	Элементы.ИнформацияОНеобходимостиОбратитьсяКАдминистратору.Видимость 	= НЕ ЕстьПравоНаРедактированиеНастроекСервиса;
	Элементы.ВключитьСервисСейчас.Видимость 								= ЕстьПравоНаРедактированиеНастроекСервиса;
	
	// Кнопка по умолчанию
	Элементы.ВключитьСервисСейчас.КнопкаПоУмолчанию = ЕстьПравоНаРедактированиеНастроекСервиса;
	Элементы.НапомнитьПозже.КнопкаПоУмолчанию 		= НЕ ЕстьПравоНаРедактированиеНастроекСервиса;
	
	Элементы.БольшеНеПоказывать.Видимость = НЕ ЭтоЗапускПроверкиКомандой;
	
	// Текст надписи
	Элементы.ИнформацияОСервисе.Заголовок = ИнформацияОСервисе();
	
КонецПроцедуры

&НаСервере
Процедура ЗапомнитьЧтоБольшеНеНужноПоказывать()
	
	Если ЭтоЗапускПроверкиПриОткрытии Тогда
		ХранилищеОбщихНастроек.Сохранить("ПроверкаКонтрагентов_ЗапускПроверкиПриОткрытии_ПредложениеУжеПоказывалось", , Истина);
	КонецЕсли;
	
	Если ЭтоЗапускПроверкиПослеЗаполнения Тогда
		ХранилищеОбщихНастроек.Сохранить("ПроверкаКонтрагентов_ЗапускПроверкиПослеЗаполнения_ПредложениеУжеПоказывалось", , Истина);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ВключитьСервисСейчасСервер()
	
	ПроверкаКонтрагентовБРО.ВключитьВыключитьПроверкуКонтрагентов(Истина);
	ПроверкаКонтрагентовБРО.ПроверитьКонтрагентовПослеВключенияПроверкиФоновоеЗадание();
	ЗапомнитьЧтоБольшеНеНужноПоказывать();
	
КонецПроцедуры

&НаСервере
Функция ИнформацияОСервисе()
	
	ЧастиСтроки = Новый Массив;
	ЧастиСтроки.Добавить(НСтр("ru = 'В программе имеется возможность использовать веб-сервис ФНС для проверки регистрации контрагентов в ЕГРН'"));
	Если ЭтоЗапускПроверкиПослеЗаполнения Тогда
		ЧастиСтроки.Добавить(НСтр("ru = ' после заполнения декларации'"));
	КонецЕсли;
	ЧастиСтроки.Добавить(НСтр("ru = ' (требуется доступ в интернет).'"));
	ЧастиСтроки.Добавить(Символы.ПС);
	ЧастиСтроки.Добавить(ПроверкаКонтрагентовБРО.СсылкаНаИнструкцию());
	
	ИнформацияОСервисе = Новый ФорматированнаяСтрока(ЧастиСтроки);
	
	Возврат ИнформацияОСервисе;
	
КонецФункции

#КонецОбласти
