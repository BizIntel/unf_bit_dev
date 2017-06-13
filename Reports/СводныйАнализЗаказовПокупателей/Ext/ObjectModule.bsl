﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	НастройкиОтчета.ПрограммноеИзменениеФормыОтчета = Истина;
	
	НастройкиВариантов["Основной"].Вставить("РежимПериода", "НаДату");
	НастройкиВариантов["ВыполнениеИОплатаЗаказНарядов"].Вставить("РежимПериода", "НаДату");
	
	НастройкиВариантов["Основной"].Рекомендуемый = Истина;
	НастройкиВариантов["ВыполнениеИОплатаЗаказНарядов"].Рекомендуемый = Истина;
	
	ЗаполнитьПредопределенныеВариантыОформления(НастройкиВариантов);
	УстановитьТегиВариантов(НастройкиВариантов);
	ДобавитьОписанияСвязанныхПолей(НастройкиВариантов);
	
КонецПроцедуры

Процедура ОбновитьНастройкиНаФорме(НастройкиОтчета, НастройкиСКД, Форма) Экспорт
	
	ДобавитьЭлементДляВыбораПараметра(
	НастройкиСКД,
	Форма,
	"СостояниеОтгрузки",
	НСтр("ru = 'Состояние отгрузки'"),
	"Все заказы,Неотгруженные,Отгруженные частично,Отгруженные полностью",
	"Все заказы");
	
	ДобавитьЭлементДляВыбораПараметра(
	НастройкиСКД,
	Форма,
	"СостояниеОплаты",
	НСтр("ru = 'Состояние оплаты'"),
	"Все заказы,Неоплаченные,Оплаченные частично,Оплаченные полностью",
	"Все заказы");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ОтчетыУНФ.ПриКомпоновкеРезультата(КомпоновщикНастроек, СхемаКомпоновкиДанных, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПредопределенныеВариантыОформления(НастройкиВариантов)
	
	Для каждого НастройкиТекВарианта Из НастройкиВариантов Цикл
		
		ВариантыОформления = НастройкиТекВарианта.Значение.ВариантыОформления;
		
		ОтчетыУНФ.ДобавитьВариантыОформленияКоличества(
		ВариантыОформления,
		"ЗарезервированоНаСкладе,ОсталосьОбеспечить,ОсталосьОтгрузить,Отгружено,РазмещеноВЗаказах,Заказано");
		
		ОтчетыУНФ.ДобавитьВариантыОформленияСумм(
		ВариантыОформления,
		"Оплачено,ОсталосьОплатить,СуммаДокумента");
		
	КонецЦикла
	
КонецПроцедуры

Процедура УстановитьТегиВариантов(НастройкиВариантов)
	
	НастройкиВариантов["Основной"].Теги = НСтр("ru = 'Заказы,Контрагенты,Покупатели,Номенклатура,Отгрузки,Оплаты,Продажи,CRM'");
	НастройкиВариантов["ВыполнениеИОплатаЗаказНарядов"].Теги = НСтр("ru = 'Заказы,Контрагенты,Покупатели,Номенклатура,Отгрузки,Оплаты,Работы'");
	
КонецПроцедуры

Процедура ДобавитьОписанияСвязанныхПолей(НастройкиВариантов)
	
	Для Каждого НастройкиТекВарианта Из НастройкиВариантов Цикл
		ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиТекВарианта.Значение.СвязанныеПоля, "Контрагент", "Справочник.Контрагенты");
		ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиТекВарианта.Значение.СвязанныеПоля, "Номенклатура", "Справочник.Номенклатура");
		ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиТекВарианта.Значение.СвязанныеПоля, "ЗаказПокупателя", "Документ.ЗаказПокупателя");
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьЭлементДляВыбораПараметра(НастройкиСКД, Форма, ИмяРеквизита, Заголовок, СписокВыбора, ЗначениеПоУмолчанию)
	
	Стр = Форма.ПоляНастроек.ПолучитьЭлементы().Добавить();
	Стр.Тип = "Параметр";
	Стр.Поле = ИмяРеквизита;
	Стр.ТипЗначения = Новый ОписаниеТипов("Строка");
	Стр.Заголовок = Заголовок;
	Стр.ВидЭлемента = "Поле";
	Стр.Реквизиты = Новый Структура;
	Стр.Элементы = Новый Структура;
	Стр.ДополнительныеПараметры = Новый Структура;
	Стр.Реквизиты.Вставить(ИмяРеквизита, ЗначениеПоУмолчанию);
	МассивРеквизитов = Новый Массив;
	Для каждого ОписаниеРеквизита Из Стр.Реквизиты Цикл
		МассивРеквизитов.Добавить(Новый РеквизитФормы(ОписаниеРеквизита.Ключ, Стр.ТипЗначения,, Стр.Заголовок));
	КонецЦикла;
	Стр.Создан = Истина;
	
	Форма.ИзменитьРеквизиты(МассивРеквизитов);
	
	Форма[ИмяРеквизита] = ЗначениеПоУмолчанию;
	НастройкиСКД.ПараметрыДанных.УстановитьЗначениеПараметра(Стр.Поле, ЗначениеПоУмолчанию);
	Элемент = Форма.Элементы.Добавить(ИмяРеквизита, Тип("ПолеФормы"), Форма.Элементы.ГруппаПараметрыЭлементы);
	Элемент.Вид = ВидПоляФормы.ПолеВвода;
	Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
	Элемент.РежимВыбораИзСписка = Истина;
	Элемент.ПутьКДанным = ИмяРеквизита;
	Для Каждого ТекЭлементВыбора Из СтрРазделить(СписокВыбора, ",", Ложь) Цикл
		Элемент.СписокВыбора.Добавить(ТекЭлементВыбора);
	КонецЦикла;
	Элемент.УстановитьДействие("ПриИзменении", "Подключаемый_ПараметрПриИзменении");
	Стр.Элементы.Вставить(Элемент.Имя, Элемент.ПутьКДанным);

КонецПроцедуры

#КонецОбласти

ЭтоОтчетУНФ = Истина;

#КонецЕсли