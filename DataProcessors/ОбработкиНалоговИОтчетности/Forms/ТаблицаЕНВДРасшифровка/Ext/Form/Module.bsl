﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ТаблицаЕНВДГруппа3.Видимость = Параметры.ПолнаяТаблица;
	
	ТаблицаЕНВД.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресОбщейТаблицы).Получить());
	
	Если НЕ Параметры.ПолнаяТаблица Тогда
		
		ТаблицаПоОКато = ПолучитьИзВременногоХранилища(Параметры.АдресТаблицыПоОкато).Получить();
		
		
		ОКАТО = ТаблицаПоОКато[Параметры.НомерСтроки].Окато;
		ИФНС  = ТаблицаПоОКато[Параметры.НомерСтроки].КодИФНС;
		
		Строки = ТаблицаЕНВД.НайтиСтроки(Новый Структура("Окато,КодИФНС",Окато, ИФНС));
		
		НоваяТаблица = ТаблицаЕНВД.Выгрузить(Строки);
		
		ТаблицаЕНВД.Загрузить(НоваяТаблица);
		
	КонецЕсли;
	
	Если Параметры.Свойство("ПоказатьДоходыИКвартал") И Параметры.ПоказатьДоходыИКвартал Тогда
		Элементы.ТаблицаЕНВДГруппа5.Видимость = Истина;
		Элементы.ТаблицаЕНВДСуммаНалога.Видимость = Ложь;
	КонецЕсли;
	
	Если ХранилищеОбщихНастроек.Загрузить("ПоказателиЕНВД","НастройкаДней") = Истина Тогда
		Элементы.ТаблицаЕНВДГруппа2.Видимость = Истина;
	Иначе
		Элементы.ТаблицаЕНВДГруппа2.Видимость = Ложь;
	КонецЕсли;

	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЕНВДВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле.Имя = "ТаблицаЕНВДВидДеятельности" Тогда
		ПоказатьЗначение(,Элементы.ТаблицаЕНВД.ТекущиеДанные.ВидДеятельности);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры
