﻿////////////////////////////////////////////////////////////////////////////////
// ИнтеграцияГИСМВызовСервераПереопределяемый: переопределяемые процедуры, 
// требующие вызова сервера.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обработчик события вызывается на сервере при получении стандартной управляемой формы.
// Если требуется переопределить выбор открываемой формы, необходимо установить в параметре <ВыбраннаяФорма>
// другое имя формы или объект метаданных формы, которую требуется открыть, и в параметре <СтандартнаяОбработка>
// установить значение Ложь.
//
// Параметры:
//  ИмяДокумента - Строка - имя документа, для которого открывается форма,
//  ВидФормы - Строка - имя стандартной формы,
//  Параметры - Структура - параметры формы,
//  ВыбраннаяФорма - Строка, УправляемаяФорма - содержит имя открываемой формы или объект метаданных Форма,
//  ДополнительнаяИнформация - Структура - дополнительная информация открытия формы,
//  СтандартнаяОбработка - Булево - признак выполнения стандартной обработки события.
//
Процедура ПриПолученииФормыДокумента(ИмяДокумента, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	Если ИмяДокумента = "МаркировкаТоваровГИСМ" Тогда
		Если ВидФормы = "ФормаОбъекта" Тогда
			ВыбраннаяФорма = "ФормаДокументаУНФ";
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
	ИначеЕсли ИмяДокумента = "ПеремаркировкаТоваровГИСМ" Тогда
		Если ВидФормы = "ФормаОбъекта" Тогда
			ВыбраннаяФорма = "ФормаДокументаУНФ";
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Получает массив номенклатуры КиЗ по переданному GTIN маркированного товара и списка номеклатуры КиЗ,
// подходящей под выбранные категории КиЗ в документе.
//
// Параметры:
//  СписокНоменклатураКиЗ	 - Массив - список номенклатуры КиЗ, отобранной по категориям КиЗ в документе.
//  GTIN					 - Массив - массив GTIN маркируемой номенклатуры.
// 
// Возвращаемое значение:
//  Массив - массив номенклатуры КиЗ
//
Функция ПолучитьМассивКиз(СписокНоменклатураКиЗ, GTIN) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Номенклатура.Ссылка КАК НоменклатураКИЗ
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|		ПО (Номенклатура.Ссылка = ХарактеристикиНоменклатуры.Владелец
	|				ИЛИ Номенклатура.Ссылка = ХарактеристикиНоменклатуры.Владелец)
	|ГДЕ
	|	Номенклатура.Ссылка В (&СписокНоменклатураКиЗ)
	|	И ЕСТЬNULL(ХарактеристикиНоменклатуры.КиЗГИСМGTIN, Номенклатура.КиЗГИСМGTIN) В(&GTIN)";
	
	Запрос.УстановитьПараметр("GTIN", GTIN);
	Запрос.УстановитьПараметр("СписокНоменклатураКиЗ", СписокНоменклатураКиЗ);
	
	Результат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("НоменклатураКИЗ");
	Возврат Результат
	
КонецФункции


// Получает массив GTIN для переданного товара
//
// Параметры:
//  Номенклатура	 - СправочникСсылка.Номенклатура - номенклатура (маркируемый товар).
//  Характеристика	 - СправочникСсылка.Номенклатура - характеристика номенклатуры (маркируемого товара).
// 
// Возвращаемое значение:
//  Массив - массив GTIN
//
Функция МассивGTINМаркированногоТовара(Номенклатура, Характеристика) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	ШтрихкодыНоменклатуры.Штрихкод
	|ИЗ
	|	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|ГДЕ
	|	ШтрихкодыНоменклатуры.Номенклатура = &Номенклатура
	|	И ШтрихкодыНоменклатуры.Характеристика = &Характеристика");
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", Характеристика);
	
	МассивШтрихкодов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Штрихкод");
	СписокGTIN =  Новый Массив;
	
	Для Каждого Штрихкод Из МассивШтрихкодов Цикл
		
		Если МенеджерОборудованияКлиентСервер.ПроверитьКорректностьGTIN(Штрихкод) Тогда
			СписокGTIN.Добавить(Штрихкод);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СписокGTIN;

	
КонецФункции

#КонецОбласти
