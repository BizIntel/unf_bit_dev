﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	
	ЭтоНовый = Объект.Ссылка.Пустая();
	Если ЭтоНовый Тогда
		УстановитьОчереднойНомерДоверенности();
	КонецЕсли;
	
	СубъектыДоверенностиНалогоплательщика_ДоверительРук = Перечисления.СубъектыДоверенностиНалогоплательщика.ДоверительРук;
	СубъектыДоверенностиНалогоплательщика_ДоверительФЛ = Перечисления.СубъектыДоверенностиНалогоплательщика.ДоверительФЛ;
	СубъектыДоверенностиНалогоплательщика_ДоверительЮЛ = Перечисления.СубъектыДоверенностиНалогоплательщика.ДоверительЮЛ;
	СубъектыДоверенностиНалогоплательщика_НотариусФЛ = Перечисления.СубъектыДоверенностиНалогоплательщика.НотариусФЛ;
	СубъектыДоверенностиНалогоплательщика_ПредставительФЛ = Перечисления.СубъектыДоверенностиНалогоплательщика.ПредставительФЛ;
	СубъектыДоверенностиНалогоплательщика_ПредставительЮЛ = Перечисления.СубъектыДоверенностиНалогоплательщика.ПредставительЮЛ;
			
	ПриИзмененииОрганизации(Истина);
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.СкрытьЭлементыФормыПриИспользованииОднойОрганизации(ЭтаФорма, "Владелец");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ДоверительРук_ФИО		= ПолучитьПредставлениеФИО(СубъектыДоверенностиНалогоплательщика_ДоверительРук);
	ДоверительФЛ_ФИО		= ПолучитьПредставлениеФИО(СубъектыДоверенностиНалогоплательщика_ДоверительФЛ);
	ПредставительФЛ_ФИО		= ПолучитьПредставлениеФИО(СубъектыДоверенностиНалогоплательщика_ПредставительФЛ);
	НотариусФЛ_ФИО			= ПолучитьПредставлениеФИО(СубъектыДоверенностиНалогоплательщика_НотариусФЛ);
	
	ДоверительЮЛ_Адрес		= ПолучитьПредставлениеАдреса(СубъектыДоверенностиНалогоплательщика_ДоверительЮЛ);
	ДоверительФЛ_Адрес		= ПолучитьПредставлениеАдреса(СубъектыДоверенностиНалогоплательщика_ДоверительФЛ);
	ПредставительЮЛ_Адрес	= ПолучитьПредставлениеАдреса(СубъектыДоверенностиНалогоплательщика_ПредставительЮЛ);
	ПредставительФЛ_Адрес	= ПолучитьПредставлениеАдреса(СубъектыДоверенностиНалогоплательщика_ПредставительФЛ);
	НотариусФЛ_Адрес		= ПолучитьПредставлениеАдреса(СубъектыДоверенностиНалогоплательщика_НотариусФЛ);
	
	ДоверительФЛ_Удост		= ПолучитьПредставлениеУдостоверение(СубъектыДоверенностиНалогоплательщика_ДоверительФЛ);
	ПредставительФЛ_Удост	= ПолучитьПредставлениеУдостоверение(СубъектыДоверенностиНалогоплательщика_ПредставительФЛ);
	
	УправлениеЭУ();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ЗаполнитьДопКолонкуТЧНаКлиенте();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставительЯвляетсяЮЛПриИзменении(Элемент)
	
	УправлениеЭУ();
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверительЯвляетсяЮЛПриИзменении(Элемент)
	
	УправлениеЭУ();
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверительИмеетУЛПриИзменении(Элемент)
	
	УправлениеЭУ();
	
КонецПроцедуры

&НаКлиенте
Процедура НотариусЯвляетсяЮЛПриИзменении(Элемент)
	
	УправлениеЭУ();
	
КонецПроцедуры

&НаКлиенте
Процедура ПризнакДоверителяПриИзменении(Элемент)
	
	УправлениеЭУ();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаверенаНотариальноПриИзменении(Элемент)
	
	УправлениеЭУ();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительЯвляетсяСотрудникомПриИзменении(Элемент)
	
	УправлениеЭУ();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительФЛ_УдостНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДополнительныеПараметры = Новый Структура("РеквизитФормыДляУстановки", "ПредставительФЛ_Удост");
	ОписаниеОповещения = Новый ОписаниеОповещения("УстановитьВыбранноеЗначениеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ИзменитьУдостоверение(СубъектыДоверенностиНалогоплательщика_ПредставительФЛ, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительУЛ_УдостНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДополнительныеПараметры = Новый Структура("РеквизитФормыДляУстановки", "ПредставительУЛ_Удост");
	ОписаниеОповещения = Новый ОписаниеОповещения("УстановитьВыбранноеЗначениеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ИзменитьУдостоверение(СубъектыДоверенностиНалогоплательщика_ПредставительФЛ, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверительФЛ_УдостНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДополнительныеПараметры = Новый Структура("РеквизитФормыДляУстановки", "ДоверительФЛ_Удост");
	ОписаниеОповещения = Новый ОписаниеОповещения("УстановитьВыбранноеЗначениеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ИзменитьУдостоверение(СубъектыДоверенностиНалогоплательщика_ДоверительФЛ, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверительУЛ_УдостНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДополнительныеПараметры = Новый Структура("РеквизитФормыДляУстановки", "ДоверительУЛ_Удост");
	ОписаниеОповещения = Новый ОписаниеОповещения("УстановитьВыбранноеЗначениеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ИзменитьУдостоверение(СубъектыДоверенностиНалогоплательщика_ДоверительФЛ, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительФЛ_ФИОНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДополнительныеПараметры = Новый Структура("РеквизитФормыДляУстановки", "ПредставительФЛ_ФИО");
	ОписаниеОповещения = Новый ОписаниеОповещения("УстановитьВыбранноеЗначениеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ИзменитьФИО(СубъектыДоверенностиНалогоплательщика_ПредставительФЛ, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительУЛ_ФИОНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДополнительныеПараметры = Новый Структура("РеквизитФормыДляУстановки", "ПредставительФЛ_ФИО");
	ОписаниеОповещения = Новый ОписаниеОповещения("УстановитьВыбранноеЗначениеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ИзменитьФИО(СубъектыДоверенностиНалогоплательщика_ПредставительФЛ, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверительФЛ_ФИОНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДополнительныеПараметры = Новый Структура("РеквизитФормыДляУстановки", "ДоверительФЛ_ФИО");
	ОписаниеОповещения = Новый ОписаниеОповещения("УстановитьВыбранноеЗначениеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ИзменитьФИО(СубъектыДоверенностиНалогоплательщика_ДоверительФЛ, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверительУЛ_ФИОНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДополнительныеПараметры = Новый Структура("РеквизитФормыДляУстановки", "ДоверительФЛ_ФИО");
	ОписаниеОповещения = Новый ОписаниеОповещения("УстановитьВыбранноеЗначениеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ИзменитьФИО(СубъектыДоверенностиНалогоплательщика_ДоверительФЛ, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура НотариусФЛ_ФИОНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДополнительныеПараметры = Новый Структура("РеквизитФормыДляУстановки", "НотариусФЛ_ФИО");
	ОписаниеОповещения = Новый ОписаниеОповещения("УстановитьВыбранноеЗначениеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ИзменитьФИО(СубъектыДоверенностиНалогоплательщика_НотариусФЛ, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура НотариусУЛ_ФИОНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДополнительныеПараметры = Новый Структура("РеквизитФормыДляУстановки", "НотариусФЛ_ФИО");
	ОписаниеОповещения = Новый ОписаниеОповещения("УстановитьВыбранноеЗначениеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ИзменитьФИО(СубъектыДоверенностиНалогоплательщика_НотариусФЛ, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверительРук_ФИОНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДополнительныеПараметры = Новый Структура("РеквизитФормыДляУстановки", "ДоверительРук_ФИО");
	ОписаниеОповещения = Новый ОписаниеОповещения("УстановитьВыбранноеЗначениеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ИзменитьФИО(СубъектыДоверенностиНалогоплательщика_ДоверительРук, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительФЛ_ФИООчистка(Элемент, СтандартнаяОбработка)
	
	ОчиститьФИО(СубъектыДоверенностиНалогоплательщика_ПредставительФЛ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительУЛ_ФИООчистка(Элемент, СтандартнаяОбработка)
	
	ОчиститьФИО(СубъектыДоверенностиНалогоплательщика_ПредставительФЛ);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверительФЛ_ФИООчистка(Элемент, СтандартнаяОбработка)
	
	ОчиститьФИО(СубъектыДоверенностиНалогоплательщика_ДоверительФЛ);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверительРук_ФИООчистка(Элемент, СтандартнаяОбработка)
	
	ОчиститьФИО(СубъектыДоверенностиНалогоплательщика_ДоверительРук);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверительУЛ_ФИООчистка(Элемент, СтандартнаяОбработка)
	
	ОчиститьФИО(СубъектыДоверенностиНалогоплательщика_ДоверительФЛ);
	
КонецПроцедуры

&НаКлиенте
Процедура НотариусФЛ_ФИООчистка(Элемент, СтандартнаяОбработка)
	
	ОчиститьФИО(СубъектыДоверенностиНалогоплательщика_НотариусФЛ);
	
КонецПроцедуры

&НаКлиенте
Процедура НотариусУЛ_ФИООчистка(Элемент, СтандартнаяОбработка)
	
	ОчиститьФИО(СубъектыДоверенностиНалогоплательщика_НотариусФЛ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительФЛ_АдресНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	ДополнительныеПараметры = Новый Структура("Элемент, СубъектДоверенности",
	Элемент, СубъектыДоверенностиНалогоплательщика_ПредставительФЛ);
	
	ТипЗначения = Тип("ОписаниеОповещения");
	ПараметрыКонструктора = Новый Массив(3);
	ПараметрыКонструктора[0] = "ОткрытьФормуКонтактнойИнформацииЗавершение";
	ПараметрыКонструктора[1] = ЭтаФорма;
	ПараметрыКонструктора[2] = ДополнительныеПараметры;
	
	Оповещение = Новый(ТипЗначения, ПараметрыКонструктора);
	
	ИзменитьАдрес(СубъектыДоверенностиНалогоплательщика_ПредставительФЛ, Элемент, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	
	ПриИзмененииОрганизации();
	
КонецПроцедуры

&НаКлиенте
Процедура НотариусУЛ_АдресОчистка(Элемент, СтандартнаяОбработка)
	
	ОчиститьАдрес(СубъектыДоверенностиНалогоплательщика_НотариусФЛ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительЮЛ_АдресОчистка(Элемент, СтандартнаяОбработка)
	
	ОчиститьАдрес(СубъектыДоверенностиНалогоплательщика_ПредставительЮЛ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительФЛ_АдресОчистка(Элемент, СтандартнаяОбработка)
	
	ОчиститьАдрес(СубъектыДоверенностиНалогоплательщика_ПредставительФЛ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительУЛ_АдресОчистка(Элемент, СтандартнаяОбработка)
	
	ОчиститьАдрес(СубъектыДоверенностиНалогоплательщика_ПредставительФЛ);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверительЮЛ_АдресОчистка(Элемент, СтандартнаяОбработка)
	
	ОчиститьАдрес(СубъектыДоверенностиНалогоплательщика_ДоверительЮЛ);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверительФЛ_АдресОчистка(Элемент, СтандартнаяОбработка)
	
	ОчиститьАдрес(СубъектыДоверенностиНалогоплательщика_ДоверительФЛ);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверительУЛ_АдресОчистка(Элемент, СтандартнаяОбработка)
	
	ОчиститьАдрес(СубъектыДоверенностиНалогоплательщика_ДоверительФЛ);
	
КонецПроцедуры

&НаКлиенте
Процедура НотариусФЛ_АдресОчистка(Элемент, СтандартнаяОбработка)
	
	ОчиститьАдрес(СубъектыДоверенностиНалогоплательщика_НотариусФЛ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолномочияПредставителяПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	// формируем структуру с данными текущей строки
	ТекДанные = Элемент.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеТекущейСтроки = Новый Структура("ПризнакПолныеПолномочия, Признак01, Признак02, Признак03, Признак04, Признак05, Признак06," +
										"Признак07, Признак08, Признак09, Признак10, Признак11, Признак12, Признак13, Признак14," +
										"Признак15, Признак16, Признак17, Признак18, Признак19, Признак20, Признак21, Признак22, ОКАТО, КПП");
	ЗаполнитьЗначенияСвойств(ДанныеТекущейСтроки, Элемент.ТекущиеДанные);
	
	СтруктураПараметров = Новый Структура("ИсходныеДанныеСтроки, Организация", ДанныеТекущейСтроки, Объект.Владелец);
	
	ДополнительныеПараметры = Новый Структура("Элемент", Элемент);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПолномочияПредставителяПередНачаломИзмененияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму("Справочник.ДоверенностиНалогоплательщика.Форма.ФормаВводаПолномочий", СтруктураПараметров,,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительЮЛ_АдресНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДополнительныеПараметры = Новый Структура("Элемент, СубъектДоверенности",
	Элемент, СубъектыДоверенностиНалогоплательщика_ПредставительЮЛ);
	
	ТипЗначения = Тип("ОписаниеОповещения");
	ПараметрыКонструктора = Новый Массив(3);
	ПараметрыКонструктора[0] = "ОткрытьФормуКонтактнойИнформацииЗавершение";
	ПараметрыКонструктора[1] = ЭтаФорма;
	ПараметрыКонструктора[2] = ДополнительныеПараметры;
	
	Оповещение = Новый(ТипЗначения, ПараметрыКонструктора);
	
	ИзменитьАдрес(СубъектыДоверенностиНалогоплательщика_ПредставительЮЛ, Элемент, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительУЛ_АдресНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДополнительныеПараметры = Новый Структура("Элемент, СубъектДоверенности",
	Элемент, СубъектыДоверенностиНалогоплательщика_ПредставительФЛ);
	
	ТипЗначения = Тип("ОписаниеОповещения");
	ПараметрыКонструктора = Новый Массив(3);
	ПараметрыКонструктора[0] = "ОткрытьФормуКонтактнойИнформацииЗавершение";
	ПараметрыКонструктора[1] = ЭтаФорма;
	ПараметрыКонструктора[2] = ДополнительныеПараметры;
	
	Оповещение = Новый(ТипЗначения, ПараметрыКонструктора);
	
	ИзменитьАдрес(СубъектыДоверенностиНалогоплательщика_ПредставительФЛ, Элемент, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверительЮЛ_АдресНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДополнительныеПараметры = Новый Структура("Элемент, СубъектДоверенности",
	Элемент, СубъектыДоверенностиНалогоплательщика_ДоверительЮЛ);
	
	ТипЗначения = Тип("ОписаниеОповещения");
	ПараметрыКонструктора = Новый Массив(3);
	ПараметрыКонструктора[0] = "ОткрытьФормуКонтактнойИнформацииЗавершение";
	ПараметрыКонструктора[1] = ЭтаФорма;
	ПараметрыКонструктора[2] = ДополнительныеПараметры;
	
	Оповещение = Новый(ТипЗначения, ПараметрыКонструктора);
	
	ИзменитьАдрес(СубъектыДоверенностиНалогоплательщика_ДоверительЮЛ, Элемент, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверительФЛ_АдресНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДополнительныеПараметры = Новый Структура("Элемент, СубъектДоверенности",
	Элемент, СубъектыДоверенностиНалогоплательщика_ДоверительФЛ);
	
	ТипЗначения = Тип("ОписаниеОповещения");
	ПараметрыКонструктора = Новый Массив(3);
	ПараметрыКонструктора[0] = "ОткрытьФормуКонтактнойИнформацииЗавершение";
	ПараметрыКонструктора[1] = ЭтаФорма;
	ПараметрыКонструктора[2] = ДополнительныеПараметры;
	
	Оповещение = Новый(ТипЗначения, ПараметрыКонструктора);
	
	ИзменитьАдрес(СубъектыДоверенностиНалогоплательщика_ДоверительФЛ, Элемент, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверительУЛ_АдресНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДополнительныеПараметры = Новый Структура("Элемент, СубъектДоверенности",
	Элемент, СубъектыДоверенностиНалогоплательщика_ДоверительФЛ);
	
	ТипЗначения = Тип("ОписаниеОповещения");
	ПараметрыКонструктора = Новый Массив(3);
	ПараметрыКонструктора[0] = "ОткрытьФормуКонтактнойИнформацииЗавершение";
	ПараметрыКонструктора[1] = ЭтаФорма;
	ПараметрыКонструктора[2] = ДополнительныеПараметры;
	
	Оповещение = Новый(ТипЗначения, ПараметрыКонструктора);
	
	ИзменитьАдрес(СубъектыДоверенностиНалогоплательщика_ДоверительФЛ, Элемент, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура НотариусФЛ_АдресНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДополнительныеПараметры = Новый Структура("Элемент, СубъектДоверенности",
	Элемент, СубъектыДоверенностиНалогоплательщика_НотариусФЛ);
	
	ТипЗначения = Тип("ОписаниеОповещения");
	ПараметрыКонструктора = Новый Массив(3);
	ПараметрыКонструктора[0] = "ОткрытьФормуКонтактнойИнформацииЗавершение";
	ПараметрыКонструктора[1] = ЭтаФорма;
	ПараметрыКонструктора[2] = ДополнительныеПараметры;
	
	Оповещение = Новый(ТипЗначения, ПараметрыКонструктора);
	
	ИзменитьАдрес(СубъектыДоверенностиНалогоплательщика_НотариусФЛ, Элемент, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура НотариусУЛ_АдресНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДополнительныеПараметры = Новый Структура("Элемент, СубъектДоверенности",
	Элемент, СубъектыДоверенностиНалогоплательщика_НотариусФЛ);
	
	ТипЗначения = Тип("ОписаниеОповещения");
	ПараметрыКонструктора = Новый Массив(3);
	ПараметрыКонструктора[0] = "ОткрытьФормуКонтактнойИнформацииЗавершение";
	ПараметрыКонструктора[1] = ЭтаФорма;
	ПараметрыКонструктора[2] = ДополнительныеПараметры;
	
	Оповещение = Новый(ТипЗначения, ПараметрыКонструктора);
	
	ИзменитьАдрес(СубъектыДоверенностиНалогоплательщика_НотариусФЛ, Элемент, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолномочияПредставителяПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ДанныеТекущейСтроки = Новый Структура("ПризнакПолныеПолномочия, Признак01, Признак02, Признак03, Признак04, Признак05, Признак06," +
										"Признак07, Признак08, Признак09, Признак10, Признак11, Признак12, Признак13, Признак14," +
										"Признак15, Признак16, Признак17, Признак18, Признак19, Признак20, Признак21, Признак22, ОКАТО, КПП");
	ДанныеТекущейСтроки.Вставить("ПризнакПолныеПолномочия", Истина);
	
	СтруктураПараметров = Новый Структура("ИсходныеДанныеСтроки, Организация", ДанныеТекущейСтроки, Объект.Владелец);

	ОписаниеОповещения = Новый ОписаниеОповещения("ПолномочияПредставителяПередНачаломДобавленияЗавершение", ЭтотОбъект);
	ОткрытьФорму("Справочник.ДоверенностиНалогоплательщика.Форма.ФормаВводаПолномочий", СтруктураПараметров,,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительУЛ_УдостОчистка(Элемент, СтандартнаяОбработка)
	
	ОчиститьУдостоверение(СубъектыДоверенностиНалогоплательщика_ПредставительФЛ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительФЛ_УдостОчистка(Элемент, СтандартнаяОбработка)
	
	ОчиститьУдостоверение(СубъектыДоверенностиНалогоплательщика_ПредставительФЛ);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверительФЛ_УдостОчистка(Элемент, СтандартнаяОбработка)
	
	ОчиститьУдостоверение(СубъектыДоверенностиНалогоплательщика_ДоверительФЛ);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверительУЛ_УдостОчистка(Элемент, СтандартнаяОбработка)
	
	ОчиститьУдостоверение(СубъектыДоверенностиНалогоплательщика_ДоверительФЛ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
  УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ДобавитьРеквизит(Текст, ДобСтрока, Префикс)
	
	Если ЗначениеЗаполнено(ДобСтрока) Тогда
		Текст = Текст + Префикс + ДобСтрока;
	КонецЕсли;
	
	Возврат Текст;
	
КонецФункции

&НаКлиенте
Процедура УправлениеЭУ()
	
	Элементы.ГруппаДоверитель.Видимость = (Объект.ПризнакДоверителя <> 1);
	Если Объект.ПризнакДоверителя = 2 Тогда
		Если Объект.ДоверительЯвляетсяЮЛ = Истина Тогда
			Объект.ДоверительЯвляетсяЮЛ = Ложь;
		КонецЕсли;
		Элементы.ДоверительЯвляетсяЮЛ.Доступность = Ложь;
	Иначе
		Элементы.ДоверительЯвляетсяЮЛ.Доступность = Истина;
	КонецЕсли;
	Элементы.ГруппаНотариус.Видимость = Объект.ЗаверенаНотариально;
	
	// страница Представитель
	Если Объект.ПредставительЯвляетсяЮЛ Тогда
		Элементы.ГруппаПредставительЛевая.ТекущаяСтраница = Элементы.ГруппаПредставительЛеваяЮрлицо;
		Элементы.ГруппаПредставительПраваяОсновнаяОбычная.Видимость = Истина;
	Иначе
		Элементы.ГруппаПредставительЛевая.ТекущаяСтраница = Элементы.ГруппаПредставительЛеваяФизлицо;
		Элементы.ГруппаПредставительПраваяОсновнаяОбычная.Видимость = Ложь;
	КонецЕсли;
	Элементы.ПредставительЯвляетсяСотрудником.Видимость = НЕ Объект.ПредставительЯвляетсяЮЛ;
	Элементы.ПредставительФЛ_ОГРН.Видимость = НЕ Объект.ПредставительЯвляетсяСотрудником;
	
	// страница Доверитель
	Элементы.ДоверительИмеетУЛ.Видимость = Объект.ДоверительЯвляетсяЮЛ;
	Если Объект.ДоверительЯвляетсяЮЛ Тогда
		Элементы.ГруппаДоверительЛевая.ТекущаяСтраница = Элементы.ГруппаДоверительЛеваяЮрлицо;
		Элементы.ГруппаДоверительПравая.Видимость = Объект.ДоверительИмеетУЛ;
	Иначе
		Элементы.ГруппаДоверительЛевая.ТекущаяСтраница = Элементы.ГруппаДоверительЛеваяФизлицо;
		Элементы.ГруппаДоверительПравая.Видимость = Ложь;
	КонецЕсли;
	
	// страница Нотариус
	Если Объект.НотариусЯвляетсяЮЛ Тогда
		Элементы.ГруппаНотариусЛевая.ТекущаяСтраница = Элементы.ГруппаНотариусЛеваяЮрлицо;
		Элементы.ГруппаНотариусПравая.Видимость = Истина;
	Иначе
		Элементы.ГруппаНотариусЛевая.ТекущаяСтраница = Элементы.ГруппаНотариусЛеваяФизлицо;
		Элементы.ГруппаНотариусПравая.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОчереднойНомерДоверенности()
	
	Объект.НомерДовер = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(Объект.Код, "0");
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПредставлениеФИО(СубъектДоверенности)
	
	Представление = "";
	СтрокиФИО = Объект.ФИО.НайтиСтроки(Новый Структура("Владелец", СубъектДоверенности));
	Для Каждого СтрокаФИО Из СтрокиФИО Цикл
		ДобавитьРеквизит(Представление, СтрокаФИО.Фамилия, "");
		ДобавитьРеквизит(Представление, СтрокаФИО.Имя, " ");
		ДобавитьРеквизит(Представление, СтрокаФИО.Отчество, " ");
	КонецЦикла;
	
	Возврат Представление;
	
КонецФункции

&НаКлиенте
Функция ПолучитьПредставлениеАдреса(СубъектДоверенности)
	
	Представление = "";
	СтрокиАдреса = Объект.Адреса.НайтиСтроки(Новый Структура("Владелец", СубъектДоверенности));
	Для Каждого СтрокаАдреса Из СтрокиАдреса Цикл
		Представление = ?(ЗначениеЗаполнено(СтрокаАдреса.Индекс), СтрокаАдреса.Индекс + ", ", "")
		+ ?(ЗначениеЗаполнено(СтрокаАдреса.КодРегион), РегламентированнаяОтчетностьВызовСервера.ПолучитьНазваниеРегионаПоКоду(СтрокаАдреса.КодРегион) + ", ", "")
		+ ?(ЗначениеЗаполнено(СтрокаАдреса.Район), СтрокаАдреса.Район + ", ", "")
		+ ?(ЗначениеЗаполнено(СтрокаАдреса.Город), СтрокаАдреса.Город + ", ", "")
		+ ?(ЗначениеЗаполнено(СтрокаАдреса.НаселПункт), СтрокаАдреса.НаселПункт + ", ", "")
		+ ?(ЗначениеЗаполнено(СтрокаАдреса.Улица), СтрокаАдреса.Улица + ", ", "")
		+ ?(ЗначениеЗаполнено(СтрокаАдреса.Дом), СтрокаАдреса.Дом + ", ", "")
		+ ?(ЗначениеЗаполнено(СтрокаАдреса.Корпус), СтрокаАдреса.Корпус + ", ", "")
		+ ?(ЗначениеЗаполнено(СтрокаАдреса.Кварт), СтрокаАдреса.Кварт, "");
	КонецЦикла;
	
	Возврат Представление;
	
КонецФункции

&НаКлиенте
Функция ПолучитьПредставлениеУдостоверение(СубъектДоверенности)
	
	Представление = "";
	СтрокиУдостоверения = Объект.УдЛичности.НайтиСтроки(Новый Структура("Владелец", СубъектДоверенности));
	Для Каждого СтрокаУдостоверения Из СтрокиУдостоверения Цикл
		ДобавитьРеквизит(Представление, СтрокаУдостоверения.ВидДок, 					"");
		ДобавитьРеквизит(Представление, СтрокаУдостоверения.СерДок, 					" ");
		ДобавитьРеквизит(Представление, СтрокаУдостоверения.НомДок, 					" №");
		ДобавитьРеквизит(Представление, Формат(СтрокаУдостоверения.ДатаДок, "ДЛФ=DD"), 	" выдан ");
		ДобавитьРеквизит(Представление, СтрокаУдостоверения.ВыдДок, 					" ");
		ДобавитьРеквизит(Представление, СтрокаУдостоверения.КодВыдДок, 					", код подразделения:");
	КонецЦикла;
	
	Возврат Представление;
	
КонецФункции

&НаСервере
Процедура ПриИзмененииОрганизации(ПерерисовыватьФорму = Истина)
	
	Если ПерерисовыватьФорму Тогда
		Элементы.ПолномочияПредставителяКПП.Видимость = РегламентированнаяОтчетностьВызовСервера.ЭтоЮридическоеЛицо(Объект.Владелец);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьАдрес(СубъектДоверенности)
	
	СтрокиАдреса = Объект.Адреса.НайтиСтроки(Новый Структура("Владелец", СубъектДоверенности));
	Для Каждого СтрокаАдреса Из СтрокиАдреса Цикл
		
		СтрокаАдреса.Индекс		= "";
		СтрокаАдреса.КодРегион	= "";
		СтрокаАдреса.Район		= "";
		СтрокаАдреса.Город		= "";
		СтрокаАдреса.НаселПункт	= "";
		СтрокаАдреса.Улица		= "";
		СтрокаАдреса.Дом		= "";
		СтрокаАдреса.Корпус		= "";
		СтрокаАдреса.Кварт		= "";
		
		Модифицированность = Истина;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьФИО(СубъектДоверенности)
	
	СтрокиФИО = Объект.ФИО.НайтиСтроки(Новый Структура("Владелец", СубъектДоверенности));
	Для Каждого СтрокаФИО Из СтрокиФИО Цикл
		
		СтрокаФИО.Фамилия 	= "";
		СтрокаФИО.Имя 		= "";
		СтрокаФИО.Отчество 	= "";
		
		Модифицированность = Истина;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьУдостоверение(СубъектДоверенности)
	
	СтрокиУдостоверения = Объект.УдЛичности.НайтиСтроки(Новый Структура("Владелец", СубъектДоверенности));
	Для Каждого СтрокаУдостоверения Из СтрокиУдостоверения Цикл
		
		СтрокаУдостоверения.СерДок 		= "";
		СтрокаУдостоверения.НомДок 		= "";
		СтрокаУдостоверения.ДатаДок 	= '00010101';
		СтрокаУдостоверения.ВыдДок 		= "";
		СтрокаУдостоверения.КодВыдДок 	= "";
		
		Модифицированность = Истина;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьУдостоверение(СубъектДоверенности, ВыполняемоеОповещение)
	
	СтруктураДанных = Новый Структура;
	
	//заполнение структуры начальных значений
	СтрокиУдостоверения = Объект.УдЛичности.НайтиСтроки(Новый Структура("Владелец", СубъектДоверенности));
	Если СтрокиУдостоверения.Количество() = 0 Тогда
		СтрокаУдостоверения = Объект.УдЛичности.Добавить();
		СтрокаУдостоверения.Владелец = СубъектДоверенности;
	Иначе
		СтрокаУдостоверения = СтрокиУдостоверения[0];
	КонецЕсли;
	
	СтруктураДанных.Вставить("ДокументВид",					СтрокаУдостоверения.ВидДок); 
	СтруктураДанных.Вставить("ДокументСерия",				СтрокаУдостоверения.СерДок); 
	СтруктураДанных.Вставить("ДокументНомер",				СтрокаУдостоверения.НомДок);
	СтруктураДанных.Вставить("ДокументДатаВыдачи",			СтрокаУдостоверения.ДатаДок);
	СтруктураДанных.Вставить("ДокументКемВыдан",			СтрокаУдостоверения.ВыдДок);
	СтруктураДанных.Вставить("ДокументКодПодразделения",	СтрокаУдостоверения.КодВыдДок);
	
	ДополнительныеПараметры = Новый Структура("ВыполняемоеОповещение, СтрокаУдостоверения, СубъектДоверенности", ВыполняемоеОповещение, СтрокаУдостоверения, СубъектДоверенности);
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменитьУдостоверениеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму("Справочник.ДоверенностиНалогоплательщика.Форма.ФормаВводаУдостоверения", Новый Структура("СтруктураДанных", СтруктураДанных), ЭтаФорма,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьУдостоверениеЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	ВыполняемоеОповещение = ДополнительныеПараметры.ВыполняемоеОповещение;
	СтрокаУдостоверения = ДополнительныеПараметры.СтрокаУдостоверения;
	СубъектДоверенности = ДополнительныеПараметры.СубъектДоверенности;
	
	Если РезультатВыбора <> Неопределено Тогда
		
		СтрокаУдостоверения.ВидДок = РезультатВыбора.ДокументВид;
		СтрокаУдостоверения.СерДок = РезультатВыбора.ДокументСерия;
		СтрокаУдостоверения.НомДок = РезультатВыбора.ДокументНомер;
		СтрокаУдостоверения.ДатаДок = РезультатВыбора.ДокументДатаВыдачи;
		СтрокаУдостоверения.ВыдДок = РезультатВыбора.ДокументКемВыдан;
		СтрокаУдостоверения.КодВыдДок = РезультатВыбора.ДокументКодПодразделения;
		
		Модифицированность = Истина;
		
		Результат = ПолучитьПредставлениеУдостоверение(СубъектДоверенности);
		
	Иначе
		Результат = Неопределено;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьФИО(СубъектДоверенности, ВыполняемоеОповещение)
	
	СтруктураДанныхФИО = Новый Структура;
	
	//заполнение структуры начальных значений
	СтрокиФИО = Объект.ФИО.НайтиСтроки(Новый Структура("Владелец", СубъектДоверенности));
	Если СтрокиФИО.Количество() = 0 Тогда
		СтрокаФИО = Объект.ФИО.Добавить();
		СтрокаФИО.Владелец = СубъектДоверенности;
	Иначе
		СтрокаФИО = СтрокиФИО[0];
	КонецЕсли;
	
	ФормаВводаФИО = РегламентированнаяОтчетностьКлиент.ПолучитьОбщуюФормуПоИмени("ФормаВводаФИО");
	ФормаВводаФИО.Фамилия = СтрокаФИО.Фамилия;
	ФормаВводаФИО.Имя = СтрокаФИО.Имя;
	ФормаВводаФИО.Отчество = СтрокаФИО.Отчество;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменитьФИОЗавершение", ЭтотОбъект, Новый Структура("ВыполняемоеОповещение, СтрокаФИО, СубъектДоверенности", ВыполняемоеОповещение, СтрокаФИО, СубъектДоверенности));
	ФормаВводаФИО.ОписаниеОповещенияОЗакрытии = ОписаниеОповещения;
	ФормаВводаФИО.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	ФормаВводаФИО.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьФИОЗавершение(РезультатРедактирования, ДополнительныеПараметры) Экспорт
	
	ВыполняемоеОповещение = ДополнительныеПараметры.ВыполняемоеОповещение;
	СтрокаФИО = ДополнительныеПараметры.СтрокаФИО;
	СубъектДоверенности = ДополнительныеПараметры.СубъектДоверенности;
	
	Если ЗначениеЗаполнено(РезультатРедактирования) Тогда
		
		СтрокаФИО.Фамилия	= РезультатРедактирования.Фамилия;
		СтрокаФИО.Имя		= РезультатРедактирования.Имя;
		СтрокаФИО.Отчество	= РезультатРедактирования.Отчество;
		
		Модифицированность = Истина;
		Результат = ПолучитьПредставлениеФИО(СубъектДоверенности);
		
	Иначе
		Результат = Неопределено;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВыбранноеЗначениеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	РеквизитФормыДляУстановки = ДополнительныеПараметры.РеквизитФормыДляУстановки;
	
	Если СтрНайти(РеквизитФормыДляУстановки, "УЛ") > 0 Тогда
		РеквизитФормыДляУстановки = СтрЗаменить(РеквизитФормыДляУстановки, "УЛ", "ФЛ");
	КонецЕсли;
	
	Если Результат <> Неопределено Тогда
		ЭтаФорма[РеквизитФормыДляУстановки] = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуКонтактнойИнформацииЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Элемент = ДополнительныеПараметры.Элемент;
	
	Результат = ОбновитьАдрес(РезультатЗакрытия, ДополнительныеПараметры.СубъектДоверенности);
	Если Элемент.Имя = "ПредставительФЛ_Адрес" Тогда
		ОбновитьАдресПредставителяФЛ(Результат);
	ИначеЕсли Элемент.Имя = "ПредставительЮЛ_Адрес" Тогда
		ОбновитьАдресПредставителяЮЛ(Результат);
	ИначеЕсли Элемент.Имя = "ПредставительУЛ_Адрес" Тогда
		ОбновитьАдресПредставителяУЛ(Результат);
	ИначеЕсли Элемент.Имя = "ДоверительЮЛ_Адрес" Тогда
		ОбновитьАдресДоверителяЮЛ(Результат);
	ИначеЕсли Элемент.Имя = "ДоверительФЛ_Адрес" Тогда
		ОбновитьАдресДоверителяФЛ(Результат);
	ИначеЕсли Элемент.Имя = "ДоверительУЛ_Адрес" Тогда
		ОбновитьАдресДоверителяУЛ(Результат);
	ИначеЕсли Элемент.Имя = "ДоверительУЛ_Адрес" Тогда
		ОбновитьАдресДоверителяУЛ(Результат);
	ИначеЕсли Элемент.Имя = "НотариусФЛ_Адрес" Тогда
		ОбновитьАдресНотариусаФЛ(Результат);
	ИначеЕсли Элемент.Имя = "НотариусУЛ_Адрес" Тогда
		ОбновитьАдресНотариусаУЛ(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьАдресПредставителяФЛ(Результат)
	
	Если Результат <> Неопределено Тогда
		ПредставительФЛ_Адрес = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ОбновитьАдрес(РезультатРедактирования, СубъектДоверенности, СтрокаАдреса = Неопределено)
	
	Если ТипЗнч(РезультатРедактирования) = Тип("Структура") Тогда
		
		Если СтрокаАдреса = Неопределено Тогда
			СтрокиАдреса = Объект.Адреса.НайтиСтроки(Новый Структура("Владелец", СубъектДоверенности));
			Если СтрокиАдреса.Количество() > 0 Тогда
				СтрокаАдреса = СтрокиАдреса[0];
			Иначе
				Возврат Неопределено;
			КонецЕсли;
		КонецЕсли;
		
		КомпонентыАдреса = Новый Структура;
		
		КомпонентыАдреса.Вставить("Индекс",          "");
		КомпонентыАдреса.Вставить("КодРегиона",      "");
		КомпонентыАдреса.Вставить("Регион",          "");
		КомпонентыАдреса.Вставить("Район",           "");
		КомпонентыАдреса.Вставить("Город",           "");
		КомпонентыАдреса.Вставить("НаселенныйПункт", "");
		КомпонентыАдреса.Вставить("Улица",           "");
		КомпонентыАдреса.Вставить("Дом",             "");
		КомпонентыАдреса.Вставить("Корпус",          "");
		КомпонентыАдреса.Вставить("Квартира",        "");
		
		РегламентированнаяОтчетностьВызовСервера.СформироватьАдрес(РезультатРедактирования.КонтактнаяИнформация, КомпонентыАдреса);
		
		СтрокаАдреса.Индекс = КомпонентыАдреса.Индекс;
		
		СтрокаАдреса.КодРегион = КомпонентыАдреса.КодРегиона;
		
		СтрокаАдреса.Район = КомпонентыАдреса.Район;
		СтрокаАдреса.Город = КомпонентыАдреса.Город;
		СтрокаАдреса.НаселПункт = КомпонентыАдреса.НаселенныйПункт;
		СтрокаАдреса.Улица = КомпонентыАдреса.Улица;
		СтрокаАдреса.Дом = КомпонентыАдреса.Дом;
		СтрокаАдреса.Корпус = КомпонентыАдреса.Корпус;
		СтрокаАдреса.Кварт = КомпонентыАдреса.Квартира;
		
		Модифицированность = Истина;
		
		Возврат ПолучитьПредставлениеАдреса(СубъектДоверенности);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьАдресПредставителяЮЛ(Результат)
	
	Если Результат <> Неопределено Тогда
		ПредставительЮЛ_Адрес = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьАдресПредставителяУЛ(Результат)
	
	Если Результат <> Неопределено Тогда
		ПредставительФЛ_Адрес = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьАдресДоверителяЮЛ(Результат)
	
	Если Результат <> Неопределено Тогда
		ДоверительЮЛ_Адрес = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьАдресДоверителяФЛ(Результат)
	
	Если Результат <> Неопределено Тогда
		ДоверительФЛ_Адрес = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьАдресДоверителяУЛ(Результат)
	
	Если Результат <> Неопределено Тогда
		ДоверительФЛ_Адрес = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьАдресНотариусаФЛ(Результат)
	
	Если Результат <> Неопределено Тогда
		НотариусФЛ_Адрес = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьАдресНотариусаУЛ(Результат)
	
	Если Результат <> Неопределено Тогда
		НотариусФЛ_Адрес = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолномочияПредставителяПередНачаломДобавленияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		НовСтр = Объект.ПолномочияПредставителя.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, Результат);
		ЗаполнитьДопКолонкуТЧНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ИзменитьАдрес(СубъектДоверенности, Элемент, Оповещение = Неопределено)
	
	СтруктураАдресныхДанных = Новый Структура;
	
	//заполнение структуры начальных значений
	СтрокиАдреса = Объект.Адреса.НайтиСтроки(Новый Структура("Владелец", СубъектДоверенности));
	Если СтрокиАдреса.Количество() = 0 Тогда
		СтрокаАдреса = Объект.Адреса.Добавить();
		СтрокаАдреса.Владелец = СубъектДоверенности;
	Иначе
		СтрокаАдреса = СтрокиАдреса[0];
	КонецЕсли;
	
	СтруктураАдресныхДанных = Новый СписокЗначений;
	СтруктураАдресныхДанных.Добавить(СтрокаАдреса.Индекс, "Индекс"); // индекс
	СтруктураАдресныхДанных.Добавить(РегламентированнаяОтчетностьВызовСервера.ПолучитьНазваниеРегионаПоКоду(СтрокаАдреса.КодРегион), "Регион");
	СтруктураАдресныхДанных.Добавить(СтрокаАдреса.Район, "Район");
	СтруктураАдресныхДанных.Добавить(СтрокаАдреса.Город, "Город");
	СтруктураАдресныхДанных.Добавить(СтрокаАдреса.НаселПункт, "НаселенныйПункт");
	СтруктураАдресныхДанных.Добавить(СтрокаАдреса.Улица, "Улица");
	СтруктураАдресныхДанных.Добавить(СтрокаАдреса.Дом, "Дом");
	СтруктураАдресныхДанных.Добавить(СтрокаАдреса.Корпус, "Корпус");
	СтруктураАдресныхДанных.Добавить(СтрокаАдреса.Кварт, "Квартира");
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок", "Ввод адреса");
	ПараметрыФормы.Вставить("ЗначенияПолей", СтруктураАдресныхДанных);
	ПараметрыФормы.Вставить("ВидКонтактнойИнформации", ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.АдресФизЛицаПоПрописке"));
	
	Возврат ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент").ОткрытьФормуКонтактнойИнформации(ПараметрыФормы, , Оповещение);
	
КонецФункции

&НаКлиенте
Процедура ПолномочияПредставителяПередНачаломИзмененияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Элемент = ДополнительныеПараметры.Элемент;
	
	Если Результат <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Элемент.ТекущиеДанные, Результат);
		ЗаполнитьДопКолонкуТЧНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЗаполнитьДопКолонкуТЧ();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДопКолонкуТЧ()
	
	Для Каждого Стр Из Объект.ПолномочияПредставителя Цикл
		Если Стр.ПризнакПолныеПолномочия Тогда
			ПредставлениеПолномочий = "Все полномочия";
		Иначе
			ПредставлениеПолномочий = "";
			Для Инд = 1 По 22 Цикл
				ПредставлениеПризнака = Формат(Инд, "ЧЦ=2; ЧВН=");
				Если Стр["Признак" + ПредставлениеПризнака] Тогда
					ПредставлениеПолномочий = ПредставлениеПолномочий + ПредставлениеПризнака + ", ";
				КонецЕсли;
			КонецЦикла;
			ПредставлениеПолномочий = Лев(ПредставлениеПолномочий, СтрДлина(ПредставлениеПолномочий) - 2);
		КонецЕсли;
		Стр.ОбластьПолномочий = ПредставлениеПолномочий;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДопКолонкуТЧНаКлиенте()
	
	Для Каждого Стр Из Объект.ПолномочияПредставителя Цикл
		Если Стр.ПризнакПолныеПолномочия Тогда
			ПредставлениеПолномочий = "Все полномочия";
		Иначе
			ПредставлениеПолномочий = "";
			Для Инд = 1 По 22 Цикл
				ПредставлениеПризнака = Формат(Инд, "ЧЦ=2; ЧВН=");
				Если Стр["Признак" + ПредставлениеПризнака] Тогда
					ПредставлениеПолномочий = ПредставлениеПолномочий + ПредставлениеПризнака + ", ";
				КонецЕсли;
			КонецЦикла;
			ПредставлениеПолномочий = Лев(ПредставлениеПолномочий, СтрДлина(ПредставлениеПолномочий) - 2);
		КонецЕсли;
		Стр.ОбластьПолномочий = ПредставлениеПолномочий;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

