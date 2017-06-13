﻿
&НаСервере
Процедура ЗагрузитьДанные()
	
	ПризнакПодписанта = Объект.ПодписантПризнак;
	СтруктураПараметров = Объект.Ссылка.ДанныеУведомления.Получить();
	Если ЗначениеЗаполнено(СтруктураПараметров) Тогда 
		Для Каждого КлючИЗначение Из СтруктураПараметров Цикл
			Если ЗначениеЗаполнено(КлючИЗначение.Значение)
				И ПредставлениеУведомления.Области.Найти(КлючИЗначение.Ключ) <> Неопределено Тогда
				ПредставлениеУведомления.Области[КлючИЗначение.Ключ].Значение = КлючИЗначение.Значение;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьДанные() Экспорт
	
	Если ЗначениеЗаполнено(Объект.Ссылка) И Не Модифицированность Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОПереходеНаУСН;
		Объект.Организация = Организация;
		Объект.Дата = ТекущаяДатаСеанса() 
	КонецЕсли;
	
	Объект.ПодписантПризнак = ПризнакПодписанта;
	Объект.ПодписантДокумент = ПредставлениеУведомления.Области["ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ"].Значение;
	Объект.ПодписантТелефон = ПредставлениеУведомления.Области["ТЕЛЕФОН"].Значение;
	
	СтруктураПараметров = Новый Структура;
	Для Каждого Область Из ПредставлениеУведомления.Области Цикл 
		Если Область.СодержитЗначение = Истина Тогда
			СтруктураПараметров.Вставить(Область.Имя, Область.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ДанныеУведомления = Новый ХранилищеЗначения(СтруктураПараметров);
	Документ.Записать();
	ЗначениеВДанныеФормы(Документ, Объект);
	Модифицированность = Ложь;
	ЭтотОбъект.Заголовок = СтрЗаменить(ЭтотОбъект.Заголовок, " (создание)", "");
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПараметрыЗаполнения = Неопределено;
	Параметры.Свойство("ПараметрыЗаполнения", ПараметрыЗаполнения);
	
	Если Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		Организация = Объект.Организация;
	Иначе
		Организация = Параметры.Организация;
		Объект.Организация = Параметры.Организация;
		Если Параметры.Свойство("НалоговыйОрган") И ЗначениеЗаполнено(Параметры.НалоговыйОрган) Тогда 
			Объект.РегистрацияВИФНС = Параметры.НалоговыйОрган;
		Иначе
			Объект.РегистрацияВИФНС = Документы.УведомлениеОСпецрежимахНалогообложения.РегистрацияВФНСОрганизации(Организация);
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.ДатаПодписи = ТекущаяДатаСеанса();
		ЭтотОбъект.Заголовок = ЭтотОбъект.Заголовок + " (создание)";
	КонецЕсли;
	
	Разложение = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ЭтаФорма.ИмяФормы, ".");
	Объект.ИмяФормы = Разложение[3];
	Объект.ИмяОтчета = Разложение[1];
	
	Макет = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("Форма2014_1");
	ПредставлениеУведомления.Вывести(Макет);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		ЗаполнитьНачальныеДанные();
		УстановитьДанныеПоРегистрацииВИФНС();
	Иначе 
		ЗагрузитьДанные();
	КонецЕсли;
	
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗагрузитьМакетыУведомленияПростойФормы(ЭтотОбъект, Объект.ИмяОтчета, "ПараметрыФорма2014_1");
	
	РегламентированнаяОтчетность.ДобавитьКнопкуПрисоединенныеФайлы(ЭтаФорма);
	
	РегламентированнаяОтчетностьКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтотОбъект);
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганами.ОтметитьКакПрочтенное(Объект.Ссылка);
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		ЗаблокироватьДанныеДляРедактирования(Объект.Ссылка, , УникальныйИдентификатор);
	КонецЕсли;
	
	Если Параметры.Свойство("СформироватьФормуОтчетаАвтоматически") И Параметры.СформироватьФормуОтчетаАвтоматически Тогда 
		ЗаполнитьАвтоНаСервере(ПараметрыЗаполнения);
	КонецЕсли;
	
	Если Параметры.Свойство("СформироватьПечатнуюФорму") И Параметры.СформироватьПечатнуюФорму Тогда
		Модифицированность = Истина;
		СохранитьДанные();
		Отказ = Истина;
		Если ЗначениеЗаполнено(Объект.Ссылка) Тогда 
			РазблокироватьДанныеДляРедактирования(Объект.Ссылка, УникальныйИдентификатор);
		КонецЕсли;
	КонецЕсли
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИДОтчета(Знач ЭтаФормаИмя)
	
	Если СтрЧислоВхождений(ЭтаФормаИмя, "ВнешнийОтчет.") > 0 Тогда
		ЭтаФормаИмя = СтрЗаменить(ЭтаФормаИмя, "ВнешнийОтчет.", "");
	ИначеЕсли СтрЧислоВхождений(ЭтаФормаИмя, "Отчет.") > 0 Тогда
		ЭтаФормаИмя = СтрЗаменить(ЭтаФормаИмя, "Отчет.", "");
	КонецЕсли;
	ЭтаФормаИмя = Лев(ЭтаФормаИмя, СтрНайти(ЭтаФормаИмя, ".Форма.") - 1);
	
	Возврат ЭтаФормаИмя;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьАвтоНаСервере(ПараметрыЗаполнения = Неопределено)
	ПараметрыОтчета = Новый Структура();
	ПараметрыОтчета.Вставить("Организация", 			     Объект.Организация);
	ПараметрыОтчета.Вставить("УникальныйИдентификаторФормы", ЭтаФорма.УникальныйИдентификатор);
	ПараметрыОтчета.Вставить("ПараметрыЗаполнения",          ПараметрыЗаполнения);
	
	ЭтаФормаИмя = ИДОтчета(ЭтаФорма.ИмяФормы);
	Контейнер = СформироватьКонтейнерДляАвтозаполнения();
	РегламентированнаяОтчетностьПереопределяемый.ЗаполнитьОтчет(ЭтаФормаИмя, Сред(ЭтаФорма.ИмяФормы, СтрНайти(ЭтаФорма.ИмяФормы, ".Форма.") + 7), ПараметрыОтчета, Контейнер);
	ЗагрузитьПодготовленныеДанные(Контейнер);
КонецПроцедуры

&НаСервере
Функция СформироватьКонтейнерДляАвтозаполнения()
	Контейнер = Новый Структура;
	Для Каждого Обл Из ПредставлениеУведомления.Области Цикл 
		Если Обл.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник 
			И Обл.СодержитЗначение = Истина
			И Обл.Защита = Ложь Тогда 
			
			Контейнер.Вставить(Обл.Имя, Обл.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Контейнер;
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные(Контейнер)
	Для Каждого КЗ Из Контейнер Цикл 
		ПредставлениеУведомления.Области.Найти(КЗ.Ключ).Значение = КЗ.Значение;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНачальныеДанные()
	ПредставлениеУведомления.Области["КОД_НО"].Значение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.РегистрацияВИФНС, "Код");
	Объект.ДатаПодписи = ТекущаяДатаСеанса();
	ПредставлениеУведомления.Области["ДАТА_ПОДПИСИ"].Значение = Объект.ДатаПодписи;
	
	Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Организация) Тогда
		СтрокаСведений = "ИННЮЛ,НаимЮЛПол,КППЮЛ,ТелОрганизации";
		СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Организация, Объект.ДатаПодписи, СтрокаСведений);
		ПредставлениеУведомления.Области["П_ИНН"].Значение = СведенияОбОрганизации.ИННЮЛ;
		ПредставлениеУведомления.Области["ОРГАНИЗАЦИЯ"].Значение = СведенияОбОрганизации.НаимЮЛПол;
		ПредставлениеУведомления.Области["П_КПП"].Значение = СведенияОбОрганизации.КППЮЛ;
		ПредставлениеУведомления.Области["ТЕЛЕФОН"].Значение = СведенияОбОрганизации.ТелОрганизации;
	Иначе
		СтрокаСведений = "ИННФЛ,ФИО,ТелДом";
		СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Организация, Объект.ДатаПодписи, СтрокаСведений);
		ПредставлениеУведомления.Области["П_ИНН"].Значение = СведенияОбОрганизации.ИННФЛ;
		ПредставлениеУведомления.Области["ОРГАНИЗАЦИЯ"].Значение = СведенияОбОрганизации.ФИО;
		ПредставлениеУведомления.Области["ТЕЛЕФОН"].Значение = СведенияОбОрганизации.ТелДом;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияПриИзмененииСодержимогоОбласти(Элемент, Область)
	Если Область.Имя = "ДАТА_ПОДПИСИ" Тогда
		Объект.ДатаПодписи = Область.Значение;
		УстановитьДанныеПоРегистрацииВИФНС();
	КонецЕсли;
	
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияВыбор(Элемент, Область, СтандартнаяОбработка)
	Если Область.Имя = "ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ" Тогда 
		РегламентированнаяОтчетностьКлиент.ОткрытьФормуВыбораФИО(ЭтотОбъект, СтандартнаяОбработка, "ПредставлениеУведомления", "");
		Возврат;
	КонецЕсли;
	
	ОсобаяОбласть = СписокОбластейСОсобойОбработкой.НайтиПоЗначению(Область.Имя);
	Если ОсобаяОбласть = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПредставлениеУведомления.Области[Область.Имя].Защита Тогда
		Возврат;
	КонецЕсли;
	
	Если ОсобаяОбласть.Значение = "КОД_НО" Тогда 
		СтандартнаяОбработка = Ложь;
		НестандартнаяОбработка_КОД_НО();
	ИначеЕсли ОсобаяОбласть.Значение = "КОД_ОБЪЕКТА_НАЛОГООБЛОЖЕНИЯ" Тогда
		СтандартнаяОбработка = Ложь;
		НестандартнаяОбработка_КОД_ОБЪЕКТА_НАЛОГООБЛОЖЕНИЯ();
	ИначеЕсли ОсобаяОбласть.Значение = "КОД_ПЕРЕХОДА" Тогда
		СтандартнаяОбработка = Ложь;
		НестандартнаяОбработка_КОД_ПЕРЕХОДА();
	ИначеЕсли ОсобаяОбласть.Значение = "ПРИЗНАК_НП" Тогда
		СтандартнаяОбработка = Ложь;
		НестандартнаяОбработка_ПРИЗНАК_НП();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	Если Модифицированность Тогда
		СохранитьДанные();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Параметры.Свойство("СформироватьПечатнуюФорму") Тогда
		Модифицированность = Истина;
		СохранитьДанные();
		ПараметрыОповещения = Новый Структура("Организация, ВидУведомления", Объект.Организация, Объект.ВидУведомления);
		Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыОповещения, Объект.Ссылка);
		Отказ = Истина;
	Иначе
		УстановитьДоступностьПолей();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		ПриЗакрытииНаСервере();
	КонецЕсли;
	ПараметрыОповещения = Новый Структура("Организация, ВидУведомления", Объект.Организация, Объект.ВидУведомления);
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыОповещения, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	РегламентированнаяОтчетностьКлиент.ПередЗакрытиемРегламентированногоОтчета(ЭтаФорма, Отказ, СтандартнаяОбработка, ЗавершениеРаботы, ТекстПредупреждения);
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьДанные();
	ПараметрыОповещения = Новый Структура("Организация, ВидУведомления", Объект.Организация, Объект.ВидУведомления);
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыОповещения, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура НестандартнаяОбработка_КОД_НО()
	РегламентированнаяОтчетностьКлиент.ОткрытьФормуВыбораРегистрацииВИФНС(ЭтотОбъект, Неопределено, "НестандартнаяОбработка_КОД_НОЗавершение");
КонецПроцедуры

&НаКлиенте
Процедура НестандартнаяОбработка_КОД_НОЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда 
		Объект.РегистрацияВИФНС = Результат;
		УстановитьДанныеПоРегистрацииВИФНС();
		Модифицированность = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НестандартнаяОбработка_ПРИЗНАК_НП()
	НестандартнаяОбработкаОбработкаСпискаВыбора("ПРИЗНАК_НП", "Выбор признака налогоплательщика");
КонецПроцедуры

&НаКлиенте
Процедура НестандартнаяОбработка_КОД_ПЕРЕХОДА()
	НестандартнаяОбработкаОбработкаСпискаВыбора("КОД_ПЕРЕХОДА", "Выбор кода перехода на УСН");
КонецПроцедуры

&НаКлиенте
Процедура НестандартнаяОбработка_КОД_ОБЪЕКТА_НАЛОГООБЛОЖЕНИЯ()
	НестандартнаяОбработкаОбработкаСпискаВыбора("КОД_ОБЪЕКТА_НАЛОГООБЛОЖЕНИЯ", "Выбор кода объекта налогообложения");
КонецПроцедуры

&НаКлиенте
Процедура НестандартнаяОбработкаОбработкаСпискаВыбора(ИмяНестандартнойОбласти, НазваниеСписка, Результат = Неопределено, НужноЗаполнятьРезультат = Ложь)
	СтруктураОтбора = Новый Структура("ИмяОсобогоПоля", ИмяНестандартнойОбласти);
	Строки = ТаблицаЗначенийПредопределенныхРеквизитов.НайтиСтроки(СтруктураОтбора);
	ЗагружаемыеКоды.Очистить();
	Для Каждого Строка Из Строки Цикл 
		НоваяСтрока = ЗагружаемыеКоды.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЦикла;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок",          НазваниеСписка);
	ПараметрыФормы.Вставить("ТаблицаЗначений",    ЗагружаемыеКоды);
	ПараметрыФормы.Вставить("СтруктураДляПоиска", Новый Структура("Код", ПредставлениеУведомления.Области[ИмяНестандартнойОбласти].Значение));
	
	ДополнительныеПараметры = Новый Структура("ИмяНестандартнойОбласти", ИмяНестандартнойОбласти);
	ОписаниеОповещения = Новый ОписаниеОповещения("НестандартнаяОбработкаОбработкаСпискаВыбораЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму("Обработка.ОбщиеОбъектыРеглОтчетности.Форма.ФормаВыбораЗначенияИзТаблицы", ПараметрыФормы, ЭтотОбъект,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура НестандартнаяОбработкаОбработкаСпискаВыбораЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	ИмяНестандартнойОбласти = ДополнительныеПараметры.ИмяНестандартнойОбласти;
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПредставлениеУведомления.Области[ИмяНестандартнойОбласти].Значение = РезультатВыбора.Код;
	Модифицированность = Истина;
	
	Если ИмяНестандартнойОбласти = "КОД_ПЕРЕХОДА" Тогда
		УстановитьДоступностьПолей();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьПолей()
	
	ЦветФонаДоступный = Новый Цвет(255, 255, 192);
	ЦветФонаНедоступный = Новый Цвет(255, 255, 255);
	КодДатыПерехода = ПредставлениеУведомления.Области["КОД_ПЕРЕХОДА"].Значение;
	Если КодДатыПерехода = "1" Тогда
		ПредставлениеУведомления.Области["ГОД_ПЕРЕХОДА_1"].Защита = Ложь;
		ПредставлениеУведомления.Области["ДАТА_ПЕРЕХОДА"].Защита = Истина;
		ПредставлениеУведомления.Области["ДАТА_ПЕРЕХОДА"].Значение = "";
		ПредставлениеУведомления.Области["ГОД_ПЕРЕХОДА_1"].ЦветФона = ЦветФонаДоступный;
		ПредставлениеУведомления.Области["ДАТА_ПЕРЕХОДА"].ЦветФона = ЦветФонаНедоступный;
	ИначеЕсли КодДатыПерехода = "3" Тогда
		ПредставлениеУведомления.Области["ГОД_ПЕРЕХОДА_1"].Защита = Истина;
		ПредставлениеУведомления.Области["ДАТА_ПЕРЕХОДА"].Защита = Ложь;
		ПредставлениеУведомления.Области["ГОД_ПЕРЕХОДА_1"].Значение = "";
		ПредставлениеУведомления.Области["ГОД_ПЕРЕХОДА_1"].ЦветФона = ЦветФонаНедоступный;
		ПредставлениеУведомления.Области["ДАТА_ПЕРЕХОДА"].ЦветФона = ЦветФонаДоступный;
	Иначе
		ПредставлениеУведомления.Области["ГОД_ПЕРЕХОДА_1"].Защита = Истина;
		ПредставлениеУведомления.Области["ДАТА_ПЕРЕХОДА"].Защита = Истина;
		ПредставлениеУведомления.Области["ГОД_ПЕРЕХОДА_1"].Значение = "";
		ПредставлениеУведомления.Области["ДАТА_ПЕРЕХОДА"].Значение = "";
		ПредставлениеУведомления.Области["ГОД_ПЕРЕХОДА_1"].ЦветФона = ЦветФонаНедоступный;
		ПредставлениеУведомления.Области["ДАТА_ПЕРЕХОДА"].ЦветФона = ЦветФонаНедоступный;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СформироватьXMLНаСервере(УникальныйИдентификатор)
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ВыгрузитьДокумент(УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура СформироватьXML(Команда)
	
	ВыгружаемыеДанные = СформироватьXMLНаСервере(УникальныйИдентификатор);
	Если ВыгружаемыеДанные <> Неопределено Тогда 
		РегламентированнаяОтчетностьКлиент.ВыгрузитьФайлы(ВыгружаемыеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СформироватьПечатнуюФорму()
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ПечатьСразу();
КонецФункции

&НаСервере
Процедура УстановитьПредставителяПоФизЛицу(Физлицо)
	Если ЗначениеЗаполнено(Физлицо) Тогда 
		ДанныеПредставителя = РегламентированнаяОтчетностьПереопределяемый.ПолучитьСведенияОФизЛице(Физлицо, , Объект.ДатаПодписи);
		Объект.ПодписантФамилия = СокрЛП(ДанныеПредставителя.Фамилия);
		Объект.ПодписантИмя = СокрЛП(ДанныеПредставителя.Имя);
		Объект.ПодписантОтчество = СокрЛП(ДанныеПредставителя.Отчество);
		ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
	Иначе
		Объект.ПодписантФамилия = "";
		Объект.ПодписантИмя = "";
		Объект.ПодписантОтчество = "";
		ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение = "";
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставителяПоОрганизации()
	Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьДанныеРуководителя(Объект);
	ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
КонецПроцедуры

&НаСервере
Процедура УстановитьДанныеПоРегистрацииВИФНС()
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.РегистрацияВИФНС, "Код,Представитель,КПП,ДокументПредставителя");
	ПредставлениеУведомления.Области["КОД_НО"].Значение = Реквизиты.Код;
	ПредставлениеУведомления.Области["П_КПП"].Значение = Реквизиты.КПП;
	Если ЗначениеЗаполнено(Реквизиты.Представитель) Тогда
		ПризнакПодписанта = "2";
		УстановитьПредставителяПоФизЛицу(Реквизиты.Представитель);
		ПредставлениеУведомления.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение = "2";
		ПредставлениеУведомления.Области["ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ"].Значение = Реквизиты.ДокументПредставителя;
	Иначе
		УстановитьПредставителяПоОрганизации();
		ПризнакПодписанта = "1";
		ПредставлениеУведомления.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение = "1";
		ПредставлениеУведомления.Области["ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ"].Значение = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредварительныйПросмотр(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПредварительныйПросмотрЗавершение", ЭтотОбъект);
		ТекстВопроса = "Перед печатью необходимо сохранить изменения. Сохранить изменения?";
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 0);
		Возврат;
	ИначеЕсли Модифицированность Тогда
		СохранитьДанные();
	КонецЕсли;
	
	МассивПечати = Новый Массив;
	МассивПечати.Добавить(Объект.Ссылка);
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Документ.УведомлениеОСпецрежимахНалогообложения",
		"Уведомление", МассивПечати, Неопределено);
		
КонецПроцедуры

&НаКлиенте
Процедура ПредварительныйПросмотрЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		СохранитьДанные();
		МассивПечати = Новый Массив;
		МассивПечати.Добавить(Объект.Ссылка);
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			"Документ.УведомлениеОСпецрежимахНалогообложения",
			"Уведомление", МассивПечати, Неопределено);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПечатьУведомления(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПечатьУведомленияЗавершение", ЭтотОбъект);
		ТекстВопроса = "Перед печатью необходимо сохранить изменения. Сохранить изменения?";
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 0);
		Возврат;
	ИначеЕсли Модифицированность Тогда
		СохранитьДанные();
	КонецЕсли;
	
	ПФ = СформироватьПечатнуюФорму();
	Если ПФ <> Неопределено Тогда 
		ПФ.Напечатать(РежимИспользованияДиалогаПечати.НеИспользовать);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьУведомленияЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		СохранитьДанные();
		ПФ = СформироватьПечатнуюФорму();
		Если ПФ <> Неопределено Тогда 
			ПФ.Напечатать(РежимИспользованияДиалогаПечати.НеИспользовать);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ПараметрыОповещения = Новый Структура("Организация, ВидУведомления", Объект.Организация, Объект.ВидУведомления);
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыОповещения, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	СохранитьДанные();
	ПараметрыОповещения = Новый Структура("Организация, ВидУведомления", Объект.Организация, Объект.ВидУведомления);
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыОповещения, Объект.Ссылка);
	Закрыть(Неопределено);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Отправка в ФНС

&НаКлиенте
Процедура ОтправитьВКонтролирующийОрган(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПриНажатииНаКнопкуОтправкиВКонтролирующийОрган(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВИнтернете(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПроверитьВИнтернете(ЭтотОбъект);
	
КонецПроцедуры

#Область ПанельОтправкиВКонтролирующиеОрганы

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ПоказатьСДвухмернымШтрихкодомPDF417(Команда)
	РегламентированнаяОтчетностьКлиент.ВывестиМашиночитаемуюФормуУведомленияОСпецрежимах(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Функция СформироватьВыгрузкуИПолучитьДанные() Экспорт 
	Выгрузка = СформироватьXMLНаСервере(УникальныйИдентификатор);
	Если Выгрузка = Неопределено Тогда 
		Возврат Неопределено;
	КонецЕсли;
	Выгрузка = Выгрузка[0];
	Возврат Новый Структура("ТестВыгрузки,КодировкаВыгрузки,Данные,ИмяФайла", 
			Выгрузка.ТестВыгрузки, Выгрузка.КодировкаВыгрузки, 
			Отчеты[Объект.ИмяОтчета].ПолучитьМакет("TIFF_2014_1"),
			"1150001_5.02000_02.tif");
КонецФункции

&НаКлиенте
Процедура СохранитьНаКлиенте(Автосохранение = Ложь,ВыполняемоеОповещение = Неопределено) Экспорт 
	
	СохранитьДанные();
	Если ВыполняемоеОповещение <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьВыгрузкуНаСервере()
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ПроверитьДокумент(УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВыгрузку(Команда)
	ПроверитьВыгрузкуНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьПрисоединенныеФайлы(Команда)
	
	РегламентированнаяОтчетностьКлиент.СохранитьУведомлениеИОткрытьФормуПрисоединенныеФайлы(ЭтаФорма);
	
КонецПроцедуры