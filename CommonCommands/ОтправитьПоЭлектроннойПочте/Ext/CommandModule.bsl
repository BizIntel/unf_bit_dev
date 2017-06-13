﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ИмяФормы = "";
	ПараметрыФормы = Новый Структура;
	
	Если ПараметрКоманды.Количество() = 1
		И ЭтоПредметШаблона(ПараметрКоманды[0])
		И ЕстьДоступныеШаблоны(ПараметрКоманды[0]) Тогда
		
		ИмяФормы = "Справочник.ШаблоныСообщений.Форма.СформироватьСообщение";
		ПараметрыФормы.Вставить("ВидСообщения", "Письмо");
		ПараметрыФормы.Вставить("Предмет", ПараметрКоманды[0]);
		
	Иначе
		
		ИмяФормы = "ОбщаяФорма.ВыборПечатныхФормДляОтправки";
		ДополнительныеПараметрыПечати = Неопределено;
		ЗаполнитьДополнительныеПараметрыПечати(ДополнительныеПараметрыПечати, ПараметрыВыполненияКоманды);
		
		ПараметрыФормы.Вставить("ИмяФормыОбъектаПечати",	ПараметрыВыполненияКоманды.Источник.ИмяФормы);
		ПараметрыФормы.Вставить("ОбъектыОтправки",			ПараметрКоманды);
		Если ДополнительныеПараметрыПечати <> Неопределено Тогда
			ПараметрыФормы.Вставить("ДополнительныеПараметрыПечати", ДополнительныеПараметрыПечати);
		КонецЕсли;
		
	КонецЕсли;
	
	ОткрытьФорму(ИмяФормы,
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка
	);
	СтатистикаИспользованияФормКлиент.ПроверитьЗаписатьСтатистикуКоманды(
		"ОтправитьПоЭлектроннойПочте",
		ПараметрыВыполненияКоманды.Источник
	);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДополнительныеПараметрыПечати(ДополнительныеПараметры, ПараметрыВыполненияКоманды)
	
	Если ПараметрыВыполненияКоманды.Источник.ИмяФормы = "Справочник.ДоговорыКонтрагентов.Форма.ФормаЭлемента" Тогда
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ДокументОткрытия", ПараметрыВыполненияКоманды.Источник.ДокументОткрытия);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ЭтоПредметШаблона(ПараметрКоманды)
	
	ТипыПредметовШаблонов = Новый Массив;
	ТипыПредметовШаблонов.Добавить(Тип("СправочникСсылка.Контрагенты"));
	ТипыПредметовШаблонов.Добавить(Тип("СправочникСсылка.КонтактныеЛица"));
	ТипыПредметовШаблонов.Добавить(Тип("ДокументСсылка.АктВыполненныхРабот"));
	ТипыПредметовШаблонов.Добавить(Тип("ДокументСсылка.ЗаданиеНаРаботу"));
	ТипыПредметовШаблонов.Добавить(Тип("ДокументСсылка.ЗаказНаПроизводство"));
	ТипыПредметовШаблонов.Добавить(Тип("ДокументСсылка.ЗаказПокупателя"));
	ТипыПредметовШаблонов.Добавить(Тип("ДокументСсылка.ЗаказПоставщику"));
	ТипыПредметовШаблонов.Добавить(Тип("ДокументСсылка.ПриемИПередачаВРемонт"));
	ТипыПредметовШаблонов.Добавить(Тип("ДокументСсылка.Событие"));
	ТипыПредметовШаблонов.Добавить(Тип("ДокументСсылка.СчетНаОплату"));
	
	Возврат ТипыПредметовШаблонов.Найти(ТипЗнч(ПараметрКоманды)) <> Неопределено;
	
КонецФункции

&НаСервере
Функция ЕстьДоступныеШаблоны(ПредметШаблона)
	Возврат ШаблоныСообщенийПереопределяемый.ЕстьДоступныеШаблоны(Истина, ПредметШаблона);
КонецФункции
