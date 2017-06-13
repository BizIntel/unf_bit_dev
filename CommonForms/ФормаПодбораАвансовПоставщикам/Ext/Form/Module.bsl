﻿// Процедура проверяет правильность заполнения реквизитов формы.
//
&НаКлиенте
Процедура ПроверитьЗаполнениеРеквизитовФормы(Отказ)
	
	// Проверка заполненности реквизитов.
	НомерСтроки = 0;
	Для каждого СтрокаПредоплата Из Предоплата Цикл
		НомерСтроки = НомерСтроки + 1;
		Если УчетВалютныхОпераций
		И НЕ ЗначениеЗаполнено(СтрокаПредоплата.Курс) Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = НСтр("ru = 'Не заполнена колонка ""Курс"" в строке '")
				+ Строка(НомерСтроки)
				+ НСтр("ru = ' списка ""Расшифровка расчетов"".'");
			Сообщение.Поле = "Документ";
			Сообщение.Сообщить();
			Отказ = Истина;
		КонецЕсли;
		Если УчетВалютныхОпераций
		И НЕ ЗначениеЗаполнено(СтрокаПредоплата.Кратность) Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = НСтр("ru = 'Не заполнена колонка ""Кратность"" в строке '")
				+ Строка(НомерСтроки)
				+ НСтр("ru = ' списка ""Расшифровка расчетов"".'");
			Сообщение.Поле = "Документ";
			Сообщение.Сообщить();
			Отказ = Истина;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(СтрокаПредоплата.СуммаРасчетов) Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = НСтр("ru = 'Не заполнена колонка ""Сумма расчетов"" в строке '")
				+ Строка(НомерСтроки)
				+ НСтр("ru = ' списка ""Расшифровка расчетов"".'");
			Сообщение.Поле = "Документ";
			Сообщение.Сообщить();
			Отказ = Истина;
		КонецЕсли;
		Если УчетВалютныхОпераций
		И НЕ ЗначениеЗаполнено(СтрокаПредоплата.СуммаПлатежа) Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = НСтр("ru = 'Не заполнена колонка ""Сумма платежа"" в строке '")
				+ Строка(НомерСтроки)
				+ НСтр("ru = ' списка ""Расшифровка расчетов"".'");
			Сообщение.Поле = "Документ";
			Сообщение.Сообщить();
			Отказ = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // ПроверитьЗаполнениеРеквизитовФормы()

// Процедура рассчитывает итоговые суммы.
//
&НаКлиенте
Процедура РассчитатьСуммыИтог()
	
	СуммаПлатежаИтог = 0;
	СуммаРасчетовИтог = 0;
	
	Для каждого ТекСтрока Из Предоплата Цикл
		СуммаПлатежаИтог = СуммаПлатежаИтог + ТекСтрока.СуммаПлатежа;
		СуммаРасчетовИтог = СуммаРасчетовИтог + ТекСтрока.СуммаРасчетов;
	КонецЦикла;
	
КонецПроцедуры // РассчитатьСуммыИтог()

// Процедура - обработчик события ПриСозданииНаСервере.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Компания = Параметры.Компания;
	Контрагент = Параметры.Контрагент;
	Договор = Параметры.Договор;
	Курс = Параметры.Курс;
	Кратность = Параметры.Кратность;
	ВалютаДокумента = Параметры.ВалютаДокумента;
	ВалютаРасчетов = Параметры.Договор.ВалютаРасчетов;
	ЕстьЗаказ = Параметры.ЕстьЗаказ;
	ЗаказВШапке = Параметры.ЗаказВШапке;
	Ссылка = Параметры.Ссылка;
	Дата = Параметры.Дата;
	СуммаДокумента = Параметры.СуммаДокумента;
	УчетВалютныхОпераций = Константы.ФункциональнаяУчетВалютныхОпераций.Получить();
	АдресПредоплатаВХранилище = Параметры.АдресПредоплатаВХранилище;
	ЭтоПодбор = Параметры.Подбор;
	
	Элементы.ПредоплатаДокумент.Видимость = Контрагент.ВестиРасчетыПоДокументам;
	Элементы.ПредоплатаЗаказ.Видимость = Контрагент.ВестиРасчетыПоЗаказам;
	Элементы.СписокАвансовДокумент.Видимость = Контрагент.ВестиРасчетыПоДокументам;
	Элементы.СписокАвансовЗаказ.Видимость = Контрагент.ВестиРасчетыПоЗаказам;
	
	Если ЗаказВШапке И Контрагент.ВестиРасчетыПоЗаказам Тогда // заказ в шапке
		Заказ = Параметры.Заказ;
		Элементы.ПредоплатаЗаказ.Видимость = Ложь;
		НоваяСтрока = СписокЗаказов.Добавить();
		НоваяСтрока.Заказ = Параметры.Заказ;
		НоваяСтрока.Всего = Параметры.СуммаДокумента;
		НоваяСтрока.ВсегоРасч = УправлениеНебольшойФирмойСервер.ПересчитатьИзВалютыВВалюту(
			Параметры.СуммаДокумента,
			?(ВалютаРасчетов = ВалютаДокумента, Курс, 1),
			Курс,
			?(ВалютаРасчетов = ВалютаДокумента, Кратность, 1),
			Кратность
		);
	ИначеЕсли ЕстьЗаказ И Контрагент.ВестиРасчетыПоЗаказам Тогда // заказ в табличной части
		Заказ = Документы.ЗаказПоставщику.ПустаяСсылка();
		Если Параметры.Свойство("Заказ")
		   И ТипЗнч(Параметры.Заказ) = Тип("Массив") Тогда
			ТаблицаЗаказов = СписокЗаказов.Выгрузить();
			Для каждого ЭлементМассива Из Параметры.Заказ Цикл
				СтрокаЗаказов = ТаблицаЗаказов.Добавить();
				СтрокаЗаказов.Заказ = ЭлементМассива.Заказ;
				СтрокаЗаказов.Всего = ЭлементМассива.Всего;
				СтрокаЗаказов.ВсегоРасч = УправлениеНебольшойФирмойСервер.ПересчитатьИзВалютыВВалюту(
					ЭлементМассива.Всего,
					?(ВалютаРасчетов = ВалютаДокумента, Курс, 1),
					Курс,
					?(ВалютаРасчетов = ВалютаДокумента, Кратность, 1),
					Кратность
				);
			КонецЦикла;
			ТаблицаЗаказов.Свернуть("Заказ", "Всего, ВсегоРасч");
			ТаблицаЗаказов.Сортировать("Заказ Возр");
			СписокЗаказов.Загрузить(ТаблицаЗаказов);
		КонецЕсли;
	Иначе // нет заказа
		Заказ = Документы.ЗаказПоставщику.ПустаяСсылка();
		НоваяСтрока = СписокЗаказов.Добавить();
		НоваяСтрока.Заказ = Документы.ЗаказПоставщику.ПустаяСсылка();
		НоваяСтрока.Всего = Параметры.СуммаДокумента;
		НоваяСтрока.ВсегоРасч = УправлениеНебольшойФирмойСервер.ПересчитатьИзВалютыВВалюту(
			Параметры.СуммаДокумента,
			?(ВалютаРасчетов = ВалютаДокумента, Курс, 1),
			Курс,
			?(ВалютаРасчетов = ВалютаДокумента, Кратность, 1),
			Кратность
		);
	КонецЕсли;
	
	Если НЕ Параметры.Подбор Тогда
		Элементы.Шапка.Видимость = Ложь;
		Элементы.Авансы.Видимость = Ложь;
		Элементы.ПредоплатаЗаполнитьАвтоматически.Видимость = Ложь;
		Заголовок = "Восстановление предоплаты";
	КонецЕсли;
	
	Элементы.ПредоплатаДокумент.ТолькоПросмотр = Параметры.Подбор;
	Элементы.ПредоплатаЗаказ.ТолькоПросмотр = Параметры.Подбор;
	
	Элементы.ПредоплатаДобавить.Видимость = НЕ Параметры.Подбор;
	Элементы.ПредоплатаСкопировать.Видимость = НЕ Параметры.Подбор;
	
	Элементы.ПредоплатаДокумент.ОграничениеТипа = Ссылка.Метаданные().ТабличныеЧасти.Предоплата.Реквизиты.Документ.Тип;
	
	Если ЕстьЗаказ Тогда
		Элементы.ПредоплатаЗаказ.ОграничениеТипа = Ссылка.Метаданные().ТабличныеЧасти.Предоплата.Реквизиты.Заказ.Тип;
	КонецЕсли;
	
	НациональнаяВалюта = Константы.НациональнаяВалюта.Получить();
	СтруктураПоВалюте = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(Дата, Новый Структура("Валюта", НациональнаяВалюта));
	КурсНациональнаяВалюта = СтруктураПоВалюте.Курс;
	КратностьНациональнаяВалюта = СтруктураПоВалюте.Кратность;
	
	ВалютаУчета = Константы.ВалютаУчета.Получить();
	СтруктураПоВалюте = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(Дата, Новый Структура("Валюта", ВалютаУчета));
	КурсВалютаУчета = СтруктураПоВалюте.Курс;
	КратностьВалютаУчета = СтруктураПоВалюте.Кратность;
	
	Если ЕстьЗаказ Тогда
		СтрокаКолонок = "
			|Документ,
			|Заказ,
			|СуммаПлатежа,
			|Курс,
			|Кратность,
			|СуммаРасчетов";
	Иначе
		СтрокаКолонок = "
			|Документ, 
			|СуммаПлатежа,
			|Курс,
			|Кратность,
			|СуммаРасчетов";
		Элементы.Предоплата.ПодчиненныеЭлементы.ПредоплатаЗаказ.Видимость = Ложь;
	КонецЕсли;
	
	Для каждого ТекСтрока Из Предоплата Цикл // для корректной работы перетаскивания
		Если НЕ ЗначениеЗаполнено(ТекСтрока.Заказ) Тогда
			ТекСтрока.Заказ = Документы.ЗаказПоставщику.ПустаяСсылка();
		КонецЕсли;
	КонецЦикла;
	
	Предоплата.Загрузить(ПолучитьИзВременногоХранилища(АдресПредоплатаВХранилище));
	
	ЗаполнитьАвансы();
	
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РассчитатьСуммыИтог();
	
КонецПроцедуры // ПриОткрытии()

// Процедура - обработчик нажатия кнопки ОК.
//
&НаКлиенте
Процедура ОК(Команда)
	
	Отказ = Ложь;
	
	ПроверитьЗаполнениеРеквизитовФормы(Отказ);
	
	Если НЕ Отказ Тогда
		ЗаписатьПодборВХранилище();
		Закрыть(КодВозвратаДиалога.OK);
	КонецЕсли;
	
КонецПроцедуры // ОК()

// Процедура - обработчик нажатия кнопки Обновить.
//
&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьАвансы();
	
КонецПроцедуры // Обновить()

// Процедура - обработчик нажатия кнопки ЗапрашиватьСумму.
//
&НаКлиенте
Процедура ЗапрашиватьСумму(Команда)
	
	ЗапрашиватьСумму = НЕ ЗапрашиватьСумму;
	Элементы.ЗапрашиватьСумму.Пометка = ЗапрашиватьСумму;
	
КонецПроцедуры // ЗапрашиватьСумму()

// Процедура помещает результаты подбора в хранилище.
//
&НаСервере
Процедура ЗаписатьПодборВХранилище() 
	
	ПредоплатаВХранилище = Предоплата.Выгрузить(, СтрокаКолонок);
	ПоместитьВоВременноеХранилище(ПредоплатаВХранилище, АдресПредоплатаВХранилище);
	
КонецПроцедуры

// Получает набор данных с сервера для процедуры ПредоплатаДокументПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеДокументПриИзменении(Документ)
	
	СтруктураДанные = Новый Структура();
	
	Если ТипЗнч(Документ) = Тип("ДокументСсылка.АвансовыйОтчет") Тогда
		СтруктураДанные.Вставить("СуммаРасчетов", Документ.Оплаты.Итог("СуммаРасчетов"));
	Иначе
		СтруктураДанные.Вставить("СуммаРасчетов", Документ.РасшифровкаПлатежа.Итог("СуммаРасчетов"));
	КонецЕсли;
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеДокументПриИзменении()

// Заполняет к зачету строкой аванса.
//
&НаКлиенте
Процедура ВыборАванса(ТекущаяСтрока)
	
	СуммаРасчетов = ТекущаяСтрока.СуммаРасчетов;
	Если ЗапрашиватьСумму Тогда
		ПоказатьВводЧисла(Новый ОписаниеОповещения("ВыборАвансаЗавершение", ЭтотОбъект, Новый Структура("ТекущаяСтрока, СуммаРасчетов", ТекущаяСтрока, СуммаРасчетов)), СуммаРасчетов, "Введите сумму расчетов", , );
        Возврат;
	КонецЕсли;
	
	ВыборАвансаФрагмент(СуммаРасчетов, ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ВыборАвансаЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ТекущаяСтрока = ДополнительныеПараметры.ТекущаяСтрока;
    СуммаРасчетов = ?(Результат = Неопределено, ДополнительныеПараметры.СуммаРасчетов, Результат);
    
    
    Если НЕ (Результат <> Неопределено) Тогда
        Возврат;
    КонецЕсли;
    
    ВыборАвансаФрагмент(СуммаРасчетов, ТекущаяСтрока);

КонецПроцедуры

&НаКлиенте
Процедура ВыборАвансаФрагмент(СуммаРасчетов, Знач ТекущаяСтрока)
    
    Перем НоваяСтрока, Строки, СтруктураПоиска;
    
    СтруктураПоиска = Новый Структура("Документ, Заказ", ТекущаяСтрока.Документ, ТекущаяСтрока.Заказ);
    Строки = Предоплата.НайтиСтроки(СтруктураПоиска);
    
    Если Строки.Количество() > 0 Тогда
        НоваяСтрока = Строки[0];
        СуммаРасчетов = СуммаРасчетов + НоваяСтрока.СуммаРасчетов;
    Иначе
        НоваяСтрока = Предоплата.Добавить();
    КонецЕсли;
    
    НоваяСтрока.Документ = ТекущаяСтрока.Документ;
    НоваяСтрока.Заказ = ТекущаяСтрока.Заказ;
    НоваяСтрока.СуммаРасчетов = СуммаРасчетов;
    
    НоваяСтрока.Курс = ?(НоваяСтрока.Курс = 0, ТекущаяСтрока.Курс, НоваяСтрока.Курс);
    НоваяСтрока.Кратность = ?(НоваяСтрока.Кратность = 0, ТекущаяСтрока.Кратность, НоваяСтрока.Кратность);
    
    Если НЕ УчетВалютныхОпераций Тогда
        НоваяСтрока.СуммаПлатежа = ТекущаяСтрока.СуммаРасчетов;
    Иначе
        Если СуммаРасчетов = ТекущаяСтрока.СуммаРасчетов
            И ВалютаДокумента = ВалютаУчета Тогда
            НоваяСтрока.СуммаПлатежа = ТекущаяСтрока.СуммаПлатежа;
        Иначе
            НоваяСтрока.СуммаПлатежа = УправлениеНебольшойФирмойКлиент.ПересчитатьИзВалютыВВалюту(
            НоваяСтрока.СуммаРасчетов,
            НоваяСтрока.Курс,
            ?(ВалютаДокумента = НациональнаяВалюта, КурсНациональнаяВалюта, Курс),
            НоваяСтрока.Кратность,
            ?(ВалютаДокумента = НациональнаяВалюта, КратностьНациональнаяВалюта, Кратность)
            );
        КонецЕсли;
    КонецЕсли;
    
    Элементы.Предоплата.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
    
    РассчитатьСуммыИтог();
    ЗаполнитьАвансы();

КонецПроцедуры

// Процедура помещает результаты выбора в подбор.
//
&НаКлиенте
Процедура СписокАвансовВыборЗначения(Элемент, СтандартнаяОбработка, Значение)
	
	СтандартнаяОбработка = Ложь;
	ТекущаяСтрока = Элемент.ТекущиеДанные;
	ВыборАванса(ТекущаяСтрока);
	
КонецПроцедуры // СписокАвансовВыборЗначения()

// Процедура - обработчик события ПриНачалеРедактирования табличной части Предоплата.
//
&НаКлиенте
Процедура ПредоплатаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока
	   И ЗаказВШапке
	   И ЗначениеЗаполнено(Заказ) Тогда
		Элемент.ТекущиеДанные.Заказ = Заказ;
	КонецЕсли;
	
	Если Копирование Тогда
		РассчитатьСуммыИтог();
		ЗаполнитьАвансы();
	КонецЕсли;
	
КонецПроцедуры // ПредоплатаПриНачалеРедактирования()

// Процедура - обработчик события ПриИзменении поля ввода СуммаРасчетов табличной части
// Предоплата. Расчитывает сумму платежа.
//
&НаКлиенте
Процедура ПредоплатаСуммаРасчетовПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Предоплата.ТекущиеДанные;
	
	СтрокаТабличнойЧасти.Курс =
		?(СтрокаТабличнойЧасти.Курс = 0,
			?(Курс = 0,
			1,
			Курс),
		СтрокаТабличнойЧасти.Курс);
			
	СтрокаТабличнойЧасти.Кратность =
		?(СтрокаТабличнойЧасти.Кратность = 0,
			?(Кратность = 0,
			1,
			Кратность),
		СтрокаТабличнойЧасти.Кратность);
	
	СтрокаТабличнойЧасти.СуммаПлатежа = УправлениеНебольшойФирмойКлиент.ПересчитатьИзВалютыВВалюту(
		СтрокаТабличнойЧасти.СуммаРасчетов,
		СтрокаТабличнойЧасти.Курс,
		?(ВалютаДокумента = НациональнаяВалюта, КурсНациональнаяВалюта, Курс),
		СтрокаТабличнойЧасти.Кратность,
		?(ВалютаДокумента = НациональнаяВалюта,КратностьНациональнаяВалюта, Кратность)
	);
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Курс табличной части
// Предоплата. Расчитывает сумму платежа.
//
&НаКлиенте
Процедура ПредоплатаКурсПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Предоплата.ТекущиеДанные;
	
	СтрокаТабличнойЧасти.Курс      = ?(СтрокаТабличнойЧасти.Курс      = 0, 1, СтрокаТабличнойЧасти.Курс);
	СтрокаТабличнойЧасти.Кратность = ?(СтрокаТабличнойЧасти.Кратность = 0, 1, СтрокаТабличнойЧасти.Кратность);
	
	СтрокаТабличнойЧасти.СуммаПлатежа = УправлениеНебольшойФирмойКлиент.ПересчитатьИзВалютыВВалюту(
		СтрокаТабличнойЧасти.СуммаРасчетов,
		СтрокаТабличнойЧасти.Курс,
		?(ВалютаДокумента = НациональнаяВалюта, КурсНациональнаяВалюта, Курс),
		СтрокаТабличнойЧасти.Кратность,
		?(ВалютаДокумента = НациональнаяВалюта,КратностьНациональнаяВалюта, Кратность)
	);
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Кратность табличной части
// Предоплата. Расчитывает сумму платежа.
//
&НаКлиенте
Процедура ПредоплатаКратностьПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Предоплата.ТекущиеДанные;
	
	СтрокаТабличнойЧасти.Курс      = ?(СтрокаТабличнойЧасти.Курс      = 0, 1, СтрокаТабличнойЧасти.Курс);
	СтрокаТабличнойЧасти.Кратность = ?(СтрокаТабличнойЧасти.Кратность = 0, 1, СтрокаТабличнойЧасти.Кратность);
	
	СтрокаТабличнойЧасти.СуммаПлатежа = УправлениеНебольшойФирмойКлиент.ПересчитатьИзВалютыВВалюту(
		СтрокаТабличнойЧасти.СуммаРасчетов,
		СтрокаТабличнойЧасти.Курс,
		?(ВалютаДокумента = НациональнаяВалюта, КурсНациональнаяВалюта, Курс),
		СтрокаТабличнойЧасти.Кратность,
		?(ВалютаДокумента = НациональнаяВалюта,КратностьНациональнаяВалюта, Кратность)
	);
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода СуммаПлатежа табличной части
// Предоплата. Расчитывает курс и кратность.
//
&НаКлиенте
Процедура ПредоплатаСуммаПлатежаПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Предоплата.ТекущиеДанные;

	СтрокаТабличнойЧасти.Курс      = ?(СтрокаТабличнойЧасти.Курс      = 0, 1, СтрокаТабличнойЧасти.Курс);
	СтрокаТабличнойЧасти.Кратность = ?(СтрокаТабличнойЧасти.Кратность = 0, 1, СтрокаТабличнойЧасти.Кратность);

	СтрокаТабличнойЧасти.Кратность = 1;

	СтрокаТабличнойЧасти.Курс =
		?(СтрокаТабличнойЧасти.СуммаРасчетов = 0,
			1,
			СтрокаТабличнойЧасти.СуммаПлатежа
		  / СтрокаТабличнойЧасти.СуммаРасчетов
		  * ?(ВалютаДокумента = НациональнаяВалюта,
			КурсНациональнаяВалюта,
		Курс));   

КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Документ табличной части
// Предоплата.
//
&НаКлиенте
Процедура ПредоплатаДокументПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Предоплата.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.Документ) Тогда
		СтруктураДанные = ПолучитьДанныеДокументПриИзменении(СтрокаТабличнойЧасти.Документ);
		
		СтрокаТабличнойЧасти.СуммаРасчетов = СтруктураДанные.СуммаРасчетов;
		
		СтрокаТабличнойЧасти.Курс = 
			?(СтрокаТабличнойЧасти.Курс = 0,
				?(Курс = 0,
				1,
				Курс),
			СтрокаТабличнойЧасти.Курс);
			
		СтрокаТабличнойЧасти.Кратность =
			?(СтрокаТабличнойЧасти.Кратность = 0,
				?(Кратность = 0,
				1,
				Кратность),
			СтрокаТабличнойЧасти.Кратность);
										
		СтрокаТабличнойЧасти.СуммаПлатежа = УправлениеНебольшойФирмойКлиент.ПересчитатьИзВалютыВВалюту(
			СтрокаТабличнойЧасти.СуммаРасчетов,
			СтрокаТабличнойЧасти.Курс,
			?(ВалютаДокумента = НациональнаяВалюта, КурсНациональнаяВалюта, Курс),
  			СтрокаТабличнойЧасти.Кратность,
			?(ВалютаДокумента = НациональнаяВалюта,КратностьНациональнаяВалюта, Кратность));  
		
	КонецЕсли;
	
КонецПроцедуры // ПредоплатаДокументПриИзменении()

// Процедура - обработчик события НачалоПеретаскивания списка СписокАвансов.
//
&НаКлиенте
Процедура СписокАвансовНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Структура = Новый Структура;
	Структура.Вставить("Документ", ТекущиеДанные.Документ);
	Структура.Вставить("Заказ", ТекущиеДанные.Заказ);
	Структура.Вставить("СуммаРасчетов", ТекущиеДанные.СуммаРасчетов);
	Структура.Вставить("Курс", ТекущиеДанные.Курс);
	Структура.Вставить("Кратность", ТекущиеДанные.Кратность);
	
	ПараметрыПеретаскивания.Значение = Структура;
	
	ПараметрыПеретаскивания.ДопустимыеДействия = ДопустимыеДействияПеретаскивания.Копирование;
	
КонецПроцедуры // СписокАвансовНачалоПеретаскивания()

// Процедура - обработчик события ПроверкаПеретаскивания списка Предоплата.
//
&НаКлиенте
Процедура ПредоплатаПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Копирование;
	
КонецПроцедуры // ПредоплатаПроверкаПеретаскивания()

// Процедура - обработчик события Перетаскивание списка Предоплата.
//
&НаКлиенте
Процедура ПредоплатаПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	ТекущаяСтрока = ПараметрыПеретаскивания.Значение;
	ВыборАванса(ТекущаяСтрока);
	
КонецПроцедуры // ПредоплатаПеретаскивание()

// Процедура - обработчик события ПриИзменении списка Предоплата.
//
&НаКлиенте
Процедура ПредоплатаПриИзменении(Элемент)
	
	РассчитатьСуммыИтог();
	ЗаполнитьАвансы();
	
КонецПроцедуры // ПредоплатаПриИзменении()

// Процедура заполняет предоплату.
//
&НаСервере
Процедура ЗаполнитьПредоплату()
	
	ТаблицаЗаказов = СписокЗаказов.Выгрузить();
	
	// Заполнение предоплаты.
	Запрос = Новый Запрос;
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РасчетыСПоставщикамиОстатки.Документ КАК Документ,
	|	РасчетыСПоставщикамиОстатки.Заказ КАК Заказ,
	|	РасчетыСПоставщикамиОстатки.ДокументДата КАК ДокументДата,
	|	РасчетыСПоставщикамиОстатки.Договор.ВалютаРасчетов КАК ВалютаРасчетов,
	|	СУММА(РасчетыСПоставщикамиОстатки.СуммаОстаток) КАК СуммаОстаток,
	|	СУММА(РасчетыСПоставщикамиОстатки.СуммаВалОстаток) КАК СуммаВалОстаток
	|ПОМЕСТИТЬ ВременнаяТаблицаРасчетыСПоставщикамиОстатки
	|ИЗ
	|	(ВЫБРАТЬ
	|		РасчетыСПоставщикамиОстатки.Договор КАК Договор,
	|		РасчетыСПоставщикамиОстатки.Документ КАК Документ,
	|		РасчетыСПоставщикамиОстатки.Документ.Дата КАК ДокументДата,
	|		РасчетыСПоставщикамиОстатки.Заказ КАК Заказ,
	|		ЕСТЬNULL(РасчетыСПоставщикамиОстатки.СуммаОстаток, 0) КАК СуммаОстаток,
	|		ЕСТЬNULL(РасчетыСПоставщикамиОстатки.СуммаВалОстаток, 0) КАК СуммаВалОстаток
	|	ИЗ
	|		РегистрНакопления.РасчетыСПоставщиками.Остатки(
	|				,
	|				Организация = &Организация
	|					И Контрагент = &Контрагент
	|					И Договор = &Договор
	|					// ТекстЗаказВШапке
	|					И ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Аванс)) КАК РасчетыСПоставщикамиОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияДокументаРасчетыСПоставщиками.Договор,
	|		ДвиженияДокументаРасчетыСПоставщиками.Документ,
	|		ДвиженияДокументаРасчетыСПоставщиками.Документ.Дата,
	|		ДвиженияДокументаРасчетыСПоставщиками.Заказ,
	|		ВЫБОР
	|			КОГДА ДвиженияДокументаРасчетыСПоставщиками.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ЕСТЬNULL(ДвиженияДокументаРасчетыСПоставщиками.Сумма, 0)
	|			ИНАЧЕ ЕСТЬNULL(ДвиженияДокументаРасчетыСПоставщиками.Сумма, 0)
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА ДвиженияДокументаРасчетыСПоставщиками.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ЕСТЬNULL(ДвиженияДокументаРасчетыСПоставщиками.СуммаВал, 0)
	|			ИНАЧЕ ЕСТЬNULL(ДвиженияДокументаРасчетыСПоставщиками.СуммаВал, 0)
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.РасчетыСПоставщиками КАК ДвиженияДокументаРасчетыСПоставщиками
	|	ГДЕ
	|		ДвиженияДокументаРасчетыСПоставщиками.Регистратор = &Ссылка
	|		И ДвиженияДокументаРасчетыСПоставщиками.Период <= &Период
	|		И ДвиженияДокументаРасчетыСПоставщиками.Организация = &Организация
	|		И ДвиженияДокументаРасчетыСПоставщиками.Контрагент = &Контрагент
	|		И ДвиженияДокументаРасчетыСПоставщиками.ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Аванс)) КАК РасчетыСПоставщикамиОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыСПоставщикамиОстатки.Документ,
	|	РасчетыСПоставщикамиОстатки.Заказ,
	|	РасчетыСПоставщикамиОстатки.ДокументДата,
	|	РасчетыСПоставщикамиОстатки.Договор.ВалютаРасчетов
	|
	|ИМЕЮЩИЕ
	|	СУММА(РасчетыСПоставщикамиОстатки.СуммаВалОстаток) < 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РасчетыСПоставщикамиОстатки.Документ КАК Документ,
	|	РасчетыСПоставщикамиОстатки.Заказ КАК Заказ,
	|	РасчетыСПоставщикамиОстатки.ДокументДата КАК ДокументДата,
	|	РасчетыСПоставщикамиОстатки.ВалютаРасчетов КАК ВалютаРасчетов,
	|	-СУММА(РасчетыСПоставщикамиОстатки.СуммаУчета) КАК СуммаУчета,
	|	-СУММА(РасчетыСПоставщикамиОстатки.СуммаРасчетов) КАК СуммаРасчетов,
	|	-СУММА(РасчетыСПоставщикамиОстатки.СуммаПлатежа) КАК СуммаПлатежа,
	|	СУММА(РасчетыСПоставщикамиОстатки.СуммаУчета / ВЫБОР
	|			КОГДА ЕСТЬNULL(РасчетыСПоставщикамиОстатки.СуммаРасчетов, 0) <> 0
	|				ТОГДА РасчетыСПоставщикамиОстатки.СуммаРасчетов
	|			ИНАЧЕ 1
	|		КОНЕЦ) * (КурсыВалютыУчетаКурс / КурсыВалютыУчетаКратность) КАК Курс,
	|	1 КАК Кратность,
	|	РасчетыСПоставщикамиОстатки.КурсыВалютыДокументаКурс КАК КурсыВалютыДокументаКурс,
	|	РасчетыСПоставщикамиОстатки.КурсыВалютыДокументаКратность КАК КурсыВалютыДокументаКратность
	|ИЗ
	|	(ВЫБРАТЬ
	|		РасчетыСПоставщикамиОстатки.ВалютаРасчетов КАК ВалютаРасчетов,
	|		РасчетыСПоставщикамиОстатки.Документ КАК Документ,
	|		РасчетыСПоставщикамиОстатки.ДокументДата КАК ДокументДата,
	|		РасчетыСПоставщикамиОстатки.Заказ КАК Заказ,
	|		ЕСТЬNULL(РасчетыСПоставщикамиОстатки.СуммаОстаток, 0) КАК СуммаУчета,
	|		ЕСТЬNULL(РасчетыСПоставщикамиОстатки.СуммаВалОстаток, 0) КАК СуммаРасчетов,
	|		ЕСТЬNULL(РасчетыСПоставщикамиОстатки.СуммаОстаток, 0) * КурсыВалютыУчета.Курс * &КратностьВалютыДокумента / (&КурсВалютыДокумента * КурсыВалютыУчета.Кратность) КАК СуммаПлатежа,
	|		КурсыВалютыУчета.Курс КАК КурсыВалютыУчетаКурс,
	|		КурсыВалютыУчета.Кратность КАК КурсыВалютыУчетаКратность,
	|		&КурсВалютыДокумента КАК КурсыВалютыДокументаКурс,
	|		&КратностьВалютыДокумента КАК КурсыВалютыДокументаКратность
	|	ИЗ
	|		ВременнаяТаблицаРасчетыСПоставщикамиОстатки КАК РасчетыСПоставщикамиОстатки
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&Период, Валюта = &ВалютаУчета) КАК КурсыВалютыУчета
	|			ПО (ИСТИНА)) КАК РасчетыСПоставщикамиОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыСПоставщикамиОстатки.Документ,
	|	РасчетыСПоставщикамиОстатки.Заказ,
	|	РасчетыСПоставщикамиОстатки.ДокументДата,
	|	РасчетыСПоставщикамиОстатки.ВалютаРасчетов,
	|	КурсыВалютыУчетаКурс,
	|	КурсыВалютыУчетаКратность,
	|	РасчетыСПоставщикамиОстатки.КурсыВалютыДокументаКурс,
	|	РасчетыСПоставщикамиОстатки.КурсыВалютыДокументаКратность
	|
	|ИМЕЮЩИЕ
	|	-СУММА(РасчетыСПоставщикамиОстатки.СуммаРасчетов) > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДокументДата";
	
	Если НЕ Контрагент.ВестиРасчетыПоЗаказам Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "// ТекстЗаказВШапке", "И Заказ = &Заказ");
		Запрос.УстановитьПараметр("Заказ", Документы.ЗаказПокупателя.ПустаяСсылка());
	ИначеЕсли ЗаказВШапке
	   ИЛИ НЕ ЕстьЗаказ Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "// ТекстЗаказВШапке", "И Заказ = &Заказ");
		Запрос.УстановитьПараметр("Заказ", Заказ);
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "// ТекстЗаказВШапке", "И Заказ В (&МассивЗаказов)");
		Запрос.УстановитьПараметр("МассивЗаказов", СписокЗаказов.Выгрузить().ВыгрузитьКолонку("Заказ"));
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Организация", Компания);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Договор", Договор);
	Запрос.УстановитьПараметр("Период", Дата);
	Запрос.УстановитьПараметр("ВалютаДокумента", ВалютаДокумента);
	Запрос.УстановитьПараметр("ВалютаУчета", ВалютаУчета);
	
	Если ВалютаРасчетов = ВалютаДокумента Тогда
		Запрос.УстановитьПараметр("КурсВалютыДокумента", Курс);
		Запрос.УстановитьПараметр("КратностьВалютыДокумента", Кратность);
	Иначе
		Запрос.УстановитьПараметр("КурсВалютыДокумента", 1);
		Запрос.УстановитьПараметр("КратностьВалютыДокумента", 1);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = ТекстЗапроса;
	
	Предоплата.Очистить();
	
	ВыборкаРезультатаЗапроса = Запрос.Выполнить().Выбрать();
	
	Пока ВыборкаРезультатаЗапроса.Следующий() Цикл
		
		НайденнаяСтрока = ТаблицаЗаказов.Найти(ВыборкаРезультатаЗапроса.Заказ, "Заказ");
		
		Если НайденнаяСтрока = Неопределено
		 ИЛИ НайденнаяСтрока.ВсегоРасч = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Если ВыборкаРезультатаЗапроса.СуммаРасчетов <= НайденнаяСтрока.ВсегоРасч Тогда // сумма остатка меньше или равна чем осталось распределить
			
			НоваяСтрока = Предоплата.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаРезультатаЗапроса);
			НайденнаяСтрока.ВсегоРасч = НайденнаяСтрока.ВсегоРасч - ВыборкаРезультатаЗапроса.СуммаРасчетов;
			
		Иначе // сумма остатка больше чем нужно распределить
			
			НоваяСтрока = Предоплата.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаРезультатаЗапроса);
			
			НоваяСтрока.СуммаРасчетов = НайденнаяСтрока.ВсегоРасч;
			НоваяСтрока.СуммаПлатежа = УправлениеНебольшойФирмойСервер.ПересчитатьИзВалютыВВалюту(
				НоваяСтрока.СуммаРасчетов,
				ВыборкаРезультатаЗапроса.Курс,
				ВыборкаРезультатаЗапроса.КурсыВалютыДокументаКурс,
				ВыборкаРезультатаЗапроса.Кратность,
				ВыборкаРезультатаЗапроса.КурсыВалютыДокументаКратность
			);
			
			НайденнаяСтрока.ВсегоРасч = 0;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьПредоплату()

// Процедура - обработчик нажатия кнопки ЗаполнитьАвтоматически.
//
&НаКлиенте
Процедура ЗаполнитьАвтоматически(Команда)
	
	ЗаполнитьПредоплату();
	РассчитатьСуммыИтог();
	ЗаполнитьАвансы();
	
КонецПроцедуры // ЗаполнитьАвтоматически()

// Процедура заполняет список авансов.
//
&НаСервере
Процедура ЗаполнитьАвансы()
	
	Запрос = Новый Запрос;
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ОтобранныеАвансы.Документ КАК Документ,
	|	ВЫБОР
	|		КОГДА НЕ &ЕстьЗаказ
	|			ТОГДА &Заказ
	|		КОГДА ОтобранныеАвансы.Заказ = НЕОПРЕДЕЛЕНО
	|			ТОГДА ЗНАЧЕНИЕ(Документ.ЗаказПоставщику.ПустаяСсылка)
	|		ИНАЧЕ ОтобранныеАвансы.Заказ
	|	КОНЕЦ КАК Заказ,
	|	&ВалютаРасчетов КАК ВалютаРасчетов,
	|	ОтобранныеАвансы.СуммаРасчетов КАК СуммаРасчетов,
	|	ОтобранныеАвансы.СуммаПлатежа КАК СуммаПлатежа
	|ПОМЕСТИТЬ ТаблицаОтобранныеАвансы
	|ИЗ
	|	&ТаблицаОтобранныеАвансы КАК ОтобранныеАвансы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РасчетыСПоставщикамиОстатки.Документ КАК Документ,
	|	РасчетыСПоставщикамиОстатки.Заказ КАК Заказ,
	|	РасчетыСПоставщикамиОстатки.ДокументДата КАК ДокументДата,
	|	РасчетыСПоставщикамиОстатки.Договор.ВалютаРасчетов КАК ВалютаРасчетов,
	|	СУММА(РасчетыСПоставщикамиОстатки.СуммаОстаток) КАК СуммаОстаток,
	|	СУММА(РасчетыСПоставщикамиОстатки.СуммаВалОстаток) КАК СуммаВалОстаток
	|ПОМЕСТИТЬ ВременнаяТаблицаРасчетыСПоставщикамиОстатки
	|ИЗ
	|	(ВЫБРАТЬ
	|		РасчетыСПоставщикамиОстатки.Договор КАК Договор,
	|		РасчетыСПоставщикамиОстатки.Документ КАК Документ,
	|		РасчетыСПоставщикамиОстатки.Документ.Дата КАК ДокументДата,
	|		РасчетыСПоставщикамиОстатки.Заказ КАК Заказ,
	|		ЕСТЬNULL(РасчетыСПоставщикамиОстатки.СуммаОстаток, 0) КАК СуммаОстаток,
	|		ЕСТЬNULL(РасчетыСПоставщикамиОстатки.СуммаВалОстаток, 0) КАК СуммаВалОстаток
	|	ИЗ
	|		РегистрНакопления.РасчетыСПоставщиками.Остатки(
	|				,
	|				Организация = &Организация
	|					И Контрагент = &Контрагент
	|					И Договор = &Договор
	|					// ТекстЗаказВШапке
	|					И ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Аванс)) КАК РасчетыСПоставщикамиОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияДокументаРасчетыСПоставщиками.Договор,
	|		ДвиженияДокументаРасчетыСПоставщиками.Документ,
	|		ДвиженияДокументаРасчетыСПоставщиками.Документ.Дата,
	|		ДвиженияДокументаРасчетыСПоставщиками.Заказ,
	|		ВЫБОР
	|			КОГДА ДвиженияДокументаРасчетыСПоставщиками.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ЕСТЬNULL(ДвиженияДокументаРасчетыСПоставщиками.Сумма, 0)
	|			ИНАЧЕ ЕСТЬNULL(ДвиженияДокументаРасчетыСПоставщиками.Сумма, 0)
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА ДвиженияДокументаРасчетыСПоставщиками.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ЕСТЬNULL(ДвиженияДокументаРасчетыСПоставщиками.СуммаВал, 0)
	|			ИНАЧЕ ЕСТЬNULL(ДвиженияДокументаРасчетыСПоставщиками.СуммаВал, 0)
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.РасчетыСПоставщиками КАК ДвиженияДокументаРасчетыСПоставщиками
	|	ГДЕ
	|		ДвиженияДокументаРасчетыСПоставщиками.Регистратор = &Ссылка
	|		И ДвиженияДокументаРасчетыСПоставщиками.Период <= &Период
	|		И ДвиженияДокументаРасчетыСПоставщиками.Организация = &Организация
	|		И ДвиженияДокументаРасчетыСПоставщиками.Контрагент = &Контрагент
	|		И ДвиженияДокументаРасчетыСПоставщиками.ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Аванс)) КАК РасчетыСПоставщикамиОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыСПоставщикамиОстатки.Документ,
	|	РасчетыСПоставщикамиОстатки.Заказ,
	|	РасчетыСПоставщикамиОстатки.ДокументДата,
	|	РасчетыСПоставщикамиОстатки.Договор.ВалютаРасчетов
	|
	|ИМЕЮЩИЕ
	|	СУММА(РасчетыСПоставщикамиОстатки.СуммаВалОстаток) < 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РасчетыСПоставщикамиОстатки.Документ КАК Документ,
	|	РасчетыСПоставщикамиОстатки.Заказ КАК Заказ,
	|	РасчетыСПоставщикамиОстатки.ДокументДата КАК ДокументДата,
	|	РасчетыСПоставщикамиОстатки.ВалютаРасчетов КАК ВалютаРасчетов,
	|	-СУММА(РасчетыСПоставщикамиОстатки.СуммаУчета) КАК СуммаУчета,
	|	-СУММА(РасчетыСПоставщикамиОстатки.СуммаРасчетов) КАК СуммаРасчетов,
	|	-СУММА(РасчетыСПоставщикамиОстатки.СуммаПлатежа) КАК СуммаПлатежа,
	|	СУММА(РасчетыСПоставщикамиОстатки.СуммаУчета / ВЫБОР
	|			КОГДА ЕСТЬNULL(РасчетыСПоставщикамиОстатки.СуммаРасчетов, 0) <> 0
	|				ТОГДА РасчетыСПоставщикамиОстатки.СуммаРасчетов
	|			ИНАЧЕ 1
	|		КОНЕЦ) * (КурсыВалютыУчета.Курс / КурсыВалютыУчета.Кратность) КАК Курс,
	|	1 КАК Кратность
	|ИЗ
	|	(ВЫБРАТЬ
	|		РасчетыСПоставщикамиОстатки.ВалютаРасчетов КАК ВалютаРасчетов,
	|		РасчетыСПоставщикамиОстатки.Документ КАК Документ,
	|		РасчетыСПоставщикамиОстатки.ДокументДата КАК ДокументДата,
	|		РасчетыСПоставщикамиОстатки.Заказ КАК Заказ,
	|		ЕСТЬNULL(РасчетыСПоставщикамиОстатки.СуммаОстаток, 0) КАК СуммаУчета,
	|		ЕСТЬNULL(РасчетыСПоставщикамиОстатки.СуммаВалОстаток, 0) КАК СуммаРасчетов,
	|		ЕСТЬNULL(РасчетыСПоставщикамиОстатки.СуммаОстаток, 0) * КурсыВалютыУчета.Курс * КурсыВалютыДокумента.Кратность / (КурсыВалютыДокумента.Курс * КурсыВалютыУчета.Кратность) КАК СуммаПлатежа
	|	ИЗ
	|		ВременнаяТаблицаРасчетыСПоставщикамиОстатки КАК РасчетыСПоставщикамиОстатки
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&Период, Валюта = &ВалютаДокумента) КАК КурсыВалютыДокумента
	|			ПО (ИСТИНА)
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&Период, Валюта = &ВалютаУчета) КАК КурсыВалютыУчета
	|			ПО (ИСТИНА)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ОтобранныеАвансы.ВалютаРасчетов,
	|		ОтобранныеАвансы.Документ,
	|		ОтобранныеАвансы.Документ.Дата,
	|		ОтобранныеАвансы.Заказ,
	|		0,
	|		ОтобранныеАвансы.СуммаРасчетов,
	|		ОтобранныеАвансы.СуммаПлатежа
	|	ИЗ
	|		ТаблицаОтобранныеАвансы КАК ОтобранныеАвансы) КАК РасчетыСПоставщикамиОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&Период, Валюта = &ВалютаУчета) КАК КурсыВалютыУчета
	|		ПО (ИСТИНА)
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыСПоставщикамиОстатки.Документ,
	|	РасчетыСПоставщикамиОстатки.Заказ,
	|	РасчетыСПоставщикамиОстатки.ДокументДата,
	|	РасчетыСПоставщикамиОстатки.ВалютаРасчетов,
	|	КурсыВалютыУчета.Курс,
	|	КурсыВалютыУчета.Кратность
	|
	|ИМЕЮЩИЕ
	|	-СУММА(РасчетыСПоставщикамиОстатки.СуммаРасчетов) > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДокументДата";
	
	Запрос.УстановитьПараметр("ЕстьЗаказ", ЕстьЗаказ);
	
	Если НЕ Контрагент.ВестиРасчетыПоЗаказам Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "// ТекстЗаказВШапке", "И Заказ = &Заказ");
		Запрос.УстановитьПараметр("Заказ", Документы.ЗаказПоставщику.ПустаяСсылка());
	ИначеЕсли ЗаказВШапке
	   ИЛИ НЕ ЕстьЗаказ Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "// ТекстЗаказВШапке", "И Заказ = &Заказ");
		Запрос.УстановитьПараметр("Заказ", Заказ);
	Иначе
		Запрос.УстановитьПараметр("Заказ", Документы.ЗаказПоставщику.ПустаяСсылка());
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "// ТекстЗаказВШапке", "И Заказ В (&МассивЗаказов)");
		Запрос.УстановитьПараметр("МассивЗаказов",  СписокЗаказов.Выгрузить().ВыгрузитьКолонку("Заказ"));
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("Организация", Компания);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Договор", Договор);
	Запрос.УстановитьПараметр("Период", Дата);
	Запрос.УстановитьПараметр("ВалютаРасчетов", ВалютаРасчетов);
	Запрос.УстановитьПараметр("ВалютаДокумента", ВалютаДокумента);
	Запрос.УстановитьПараметр("ВалютаУчета", ВалютаУчета);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ТаблицаОтобранныеАвансы", Предоплата.Выгрузить());
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СписокАвансов.Загрузить(РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // ЗаполнитьАвансы()

// Процедура запрещает добавление новых строк если не разрешен ручной подбор.
//
&НаКлиенте
Процедура ПредоплатаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если ЭтоПодбор Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры // ПредоплатаПередНачаломДобавления()
