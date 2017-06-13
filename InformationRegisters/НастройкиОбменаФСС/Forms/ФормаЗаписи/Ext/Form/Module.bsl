﻿&НаКлиенте
Перем КонтекстЭДО;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.ОрганизацияСсылка) Тогда
		
		ЗаписьПоОрганизации = РегистрыСведений.НастройкиОбменаФСС.СоздатьМенеджерЗаписи();
		ЗаписьПоОрганизации.Организация = Параметры.ОрганизацияСсылка;
		ЗаписьПоОрганизации.Прочитать();
		
		Если ЗначениеЗаполнено(ЗаписьПоОрганизации.Организация) Тогда
			ЗначениеВДанныеФормы(ЗаписьПоОрганизации, Запись);
		Иначе
			Запись.Организация = Параметры.ОрганизацияСсылка;
		КонецЕсли;
		
	КонецЕсли;
	
	ЭтоЭлектроннаяПодписьВМоделиСервиса = ЭлектроннаяПодписьВМоделиСервисаБРОВызовСервера.ЭтоЭлектроннаяПодписьВМоделиСервиса(Запись.Организация);
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.СкрытьЭлементыФормыПриИспользованииОднойОрганизации(ЭтаФорма, "НадписьОрганизация");
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	Элементы.ГруппаАвтонастройка.Видимость = (КонтекстЭДОСервер <> Неопределено И КонтекстЭДОСервер.ЕстьВозможностьАвтонастройкиВУниверсальномФормате(Запись.Организация));
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ИзменениеНастроекЭДООрганизации", Запись.Организация);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СертификатСтрахователяПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения(
		"СертификатСтрахователяПредставлениеНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("Элемент", Элемент));
	
	КриптографияЭДКОКлиент.ВыбратьСертификат(
		Оповещение, ЭтоЭлектроннаяПодписьВМоделиСервиса, Запись.СертификатСтрахователяОтпечаток, "My");
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатФССПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения(
		"СертификатФССПредставлениеНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("Элемент", Элемент));
	
	КриптографияЭДКОКлиент.ВыбратьСертификат(
		Оповещение, ЭтоЭлектроннаяПодписьВМоделиСервиса, Запись.СертификатФССОтпечаток, "AddressBook");
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОбменПриИзменении(Элемент)
	
	ОбновитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатСтрахователяПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	КриптографияЭДКОКлиент.ПоказатьСертификат(
		Новый Структура("Отпечаток, ЭтоЭлектроннаяПодписьВМоделиСервиса",
		Запись.СертификатСтрахователяОтпечаток, ЭтоЭлектроннаяПодписьВМоделиСервиса));
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатФССПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	КриптографияЭДКОКлиент.ПоказатьСертификат(
		Новый Структура("Отпечаток, ЭтоЭлектроннаяПодписьВМоделиСервиса",
		Запись.СертификатФССОтпечаток, ЭтоЭлектроннаяПодписьВМоделиСервиса));
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатСтрахователяПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Запись.СертификатСтрахователяОтпечаток = "";
	СертификатСтрахователяПредставление = "";
	
	КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
		ЭтоЭлектроннаяПодписьВМоделиСервиса,
		Элемент,
		Запись.СертификатСтрахователяОтпечаток,
		ЭтотОбъект,
		"СертификатСтрахователяПредставление");
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатФССПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Запись.СертификатФССОтпечаток = "";
	СертификатФССПредставление = "";
	
	КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
		ЭтоЭлектроннаяПодписьВМоделиСервиса,
		Элемент,
		Запись.СертификатФССОтпечаток,
		ЭтотОбъект,
		"СертификатФССПредставление");
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДО = Результат.КонтекстЭДО;
	
	ОбновитьДоступностьЭлементов();
	
	КонтекстЭДО.УправлениеОтображениемОрганизации(ЭтаФорма, Запись.Организация);
	
	ПараметрыОтображенияСертификатов = Новый Массив;
	
	ПараметрыОтображенияСертификата = Новый Структура;
	ПараметрыОтображенияСертификата.Вставить("ПолеВвода", 								Элементы.СертификатСтрахователяПредставление);
	ПараметрыОтображенияСертификата.Вставить("Сертификат", 								Запись.СертификатСтрахователяОтпечаток);
	ПараметрыОтображенияСертификата.Вставить("ИмяРеквизитаПредставлениеСертификата", 	"СертификатСтрахователяПредставление");
	
	ПараметрыОтображенияСертификатов.Добавить(ПараметрыОтображенияСертификата);
	
	ПараметрыОтображенияСертификата = Новый Структура;
	ПараметрыОтображенияСертификата.Вставить("ПолеВвода", 								Элементы.СертификатФССПредставление);
	ПараметрыОтображенияСертификата.Вставить("Сертификат", 								Запись.СертификатФССОтпечаток);
	ПараметрыОтображенияСертификата.Вставить("ИмяРеквизитаПредставлениеСертификата", 	"СертификатФССПредставление");
	
	ПараметрыОтображенияСертификатов.Добавить(ПараметрыОтображенияСертификата);
	
	КриптографияЭДКОКлиент.ОтобразитьПредставленияСертификатов(ПараметрыОтображенияСертификатов, ЭтотОбъект, ЭтоЭлектроннаяПодписьВМоделиСервиса);

КонецПроцедуры

&НаКлиенте
Процедура СертификатСтрахователяПредставлениеНачалоВыбораЗавершение(Результат, ВходящийКонтекст) Экспорт
	
	Элемент = ВходящийКонтекст.Элемент;
	
	Если Результат.Выполнено Тогда
		Запись.СертификатСтрахователяОтпечаток = Результат.ВыбранноеЗначение.Отпечаток;
		
		КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
			ЭтоЭлектроннаяПодписьВМоделиСервиса,
			Элемент, 
			Результат.ВыбранноеЗначение.Отпечаток, 
			ЭтотОбъект,
			"СертификатСтрахователяПредставление");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатФССПредставлениеНачалоВыбораЗавершение(Результат, ВходящийКонтекст) Экспорт
	
	Элемент = ВходящийКонтекст.Элемент;
	
	Если Результат.Выполнено Тогда
		Запись.СертификатФССОтпечаток = Результат.ВыбранноеЗначение.Отпечаток;
		
		КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
			ЭтоЭлектроннаяПодписьВМоделиСервиса,
			Элемент,
			Результат.ВыбранноеЗначение.Отпечаток,
			ЭтотОбъект,
			"СертификатФССПредставление"
			);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДоступностьЭлементов()
	
	Элементы.НадписьСертификатСтрахователя.Доступность = Запись.ИспользоватьОбмен;
	Элементы.СертификатСтрахователяПредставление.Доступность = Запись.ИспользоватьОбмен;
	Элементы.НадписьСертификатФСС.Доступность = Запись.ИспользоватьОбмен;
	Элементы.СертификатФССПредставление.Доступность = Запись.ИспользоватьОбмен;
	Элементы.НадписьАвтонастройка.Доступность = Запись.ИспользоватьОбмен;
	Элементы.ИспользоватьАвтонастройку.Доступность = Запись.ИспользоватьОбмен;
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	Элементы.ГруппаАвтонастройка.Видимость = (КонтекстЭДОСервер <> Неопределено И КонтекстЭДОСервер.ЕстьВозможностьАвтонастройкиВУниверсальномФормате(Запись.Организация));
	
КонецПроцедуры

#КонецОбласти

