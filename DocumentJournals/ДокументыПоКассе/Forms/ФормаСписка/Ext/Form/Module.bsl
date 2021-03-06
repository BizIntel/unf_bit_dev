﻿#Область ВспомогательныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПолучитьДанныеПоКассе(Период, Касса, Валюта)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДенежныеСредстваОстаткиИОбороты.СуммаВалНачальныйОстаток КАК ИнформацияСуммаВалНачальныйОстаток,
	|	ДенежныеСредстваОстаткиИОбороты.СуммаВалПриход КАК ИнформацияСуммаВалПриход,
	|	ДенежныеСредстваОстаткиИОбороты.СуммаВалРасход КАК ИнформацияСуммаВалРасход,
	|	ДенежныеСредстваОстаткиИОбороты.СуммаВалКонечныйОстаток КАК ИнформацияСуммаВалКонечныйОстаток
	|ИЗ
	|	РегистрНакопления.ДенежныеСредства.ОстаткиИОбороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			День,
	|			,
	|			БанковскийСчетКасса = &Касса
	|				И Валюта = &Валюта) КАК ДенежныеСредстваОстаткиИОбороты";
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоДня(Период));
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(Период));
	Запрос.УстановитьПараметр("Касса", Касса);
	Запрос.УстановитьПараметр("Валюта", ?(ЗначениеЗаполнено(Валюта), Валюта, Константы.НациональнаяВалюта.Получить()));
	ВыборкаРезультата = Запрос.Выполнить().Выбрать();
	
	Если ЗначениеЗаполнено(Касса) Тогда
		НомерБанковскогоСчета = ?(ТипЗнч(Касса) = Тип("СправочникСсылка.Кассы"), Касса.Наименование, Касса);
	Иначе
		НомерБанковскогоСчета = "";
	КонецЕсли;
	
	Если ВыборкаРезультата.Следующий() Тогда
		СтруктураВозврата = Новый Структура("ИнформацияСуммаВалНачальныйОстаток, ИнформацияСуммаВалКонечныйОстаток, ИнформацияСуммаВалПриход, ИнформацияСуммаВалРасход, УчетВалютныхОпераций, НомерБанковскогоСчета");
		ЗаполнитьЗначенияСвойств(СтруктураВозврата, ВыборкаРезультата);
		СтруктураВозврата.УчетВалютныхОпераций = ПолучитьФункциональнуюОпцию("УчетВалютныхОпераций");
		СтруктураВозврата.НомерБанковскогоСчета = НомерБанковскогоСчета;
		Возврат СтруктураВозврата;
	Иначе
		Возврат Новый Структура(
			"ИнформацияСуммаВалКонечныйОстаток, ИнформацияСуммаВалНачальныйОстаток, ИнформацияСуммаВалПриход, ИнформацияСуммаВалРасход, УчетВалютныхОпераций, НомерБанковскогоСчета",
			0,0,0,0,Ложь,НомерБанковскогоСчета
		);
	КонецЕсли;
	
КонецФункции // ПолучитьДанныеПобанковскомуСчету()

&НаКлиенте
Процедура Подключаемый_ОбработатьАктивизациюСтрокиСписка()
	
	ТекущаяСтрока = Элементы.ДокументыПоКассе.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено
		И ТекущаяСтрока.Свойство("Дата")
		И ТекущаяСтрока.Свойство("СчетКасса")
		И ТекущаяСтрока.Свойство("Валюта") Тогда
		
		СтруктураДанные = ПолучитьДанныеПоКассе(ТекущаяСтрока.Дата, ТекущаяСтрока.СчетКасса, ТекущаяСтрока.Валюта);
		ЗаполнитьЗначенияСвойств(ЭтаФорма, СтруктураДанные);
		Дата = НСтр("ru = 'Ведомость за '") + Формат(ТекущаяСтрока.Дата, "ДЛФ=D");
		НомерБанковскогоСчета = СтруктураДанные.НомерБанковскогоСчета;
		Если СтруктураДанные.УчетВалютныхОпераций Тогда
			НомерБанковскогоСчета = НомерБанковскогоСчета + " (" + ?(ЗначениеЗаполнено(ТекущаяСтрока.Валюта), ТекущаяСтрока.Валюта, НСтр("ru = '<валюта пустая>'")) + ")";
		КонецЕсли;
		
		ТаблицаИтогов[0].Значение = ИнформацияСуммаВалНачальныйОстаток;
		ТаблицаИтогов[1].Значение = ИнформацияСуммаВалПриход;
		ТаблицаИтогов[2].Значение = ИнформацияСуммаВалРасход;
		ТаблицаИтогов[3].Значение = ИнформацияСуммаВалКонечныйОстаток;
		
	Иначе
		
		ИнформацияСуммаВалКонечныйОстаток = 0;
		ИнформацияСуммаВалНачальныйОстаток = 0;
		ИнформацияСуммаВалПриход = 0;
		ИнформацияСуммаВалРасход = 0;
		Дата = "<Не выбран документ>";
		НомерБанковскогоСчета = "";
		
	Конецесли;
	
КонецПроцедуры // ОбработатьАктивизациюСтрокиСписка()

#КонецОбласти

#Область ОбработчикиСобытий

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	// Вариант отображения итогов.
	Если НЕ ПолучитьФункциональнуюОпцию("УчетВалютныхОпераций") Тогда
		ВариантОтображенияИтогов = ПредопределенноеЗначение("Перечисление.ВариантыОтображенияИтоговБанкИКасса.ВедомостьЗаДень");
	Иначе
		ТекущийВариантОтображенияИтогов = Настройки.Получить("ВариантОтображенияИтогов");
		Если ЗначениеЗаполнено(ТекущийВариантОтображенияИтогов) Тогда
			ВариантОтображенияИтогов = ТекущийВариантОтображенияИтогов;
			ОтборВалютаВедомости = Настройки.Получить("ОтборВалютаВедомости");
			ОтборВалютаОстатков = Настройки.Получить("ОтборВалютаОстатков");
		КонецЕсли;
	КонецЕсли;
	НастройкаИтоговЗавершениеНаСервере();
	
КонецПроцедуры // ПриЗагрузкеДанныхИзНастроекНаСервере()

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если НЕ ПолучитьФункциональнуюОпцию("УчетВалютныхОпераций") Тогда
		ВариантОтображенияИтогов = ПредопределенноеЗначение("Перечисление.ВариантыОтображенияИтоговБанкИКасса.ВедомостьЗаДень");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыПоКассеПриАктивизацииСтроки(Элемент)
	
	Если ВариантОтображенияИтогов = ВедомостьЗаДень Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ОбработатьАктивизациюСтрокиСписка", 0.2, Истина);
	КонецЕсли;
	
КонецПроцедуры // ДокументыПоКассеПриАктивизацииСтроки()

&НаКлиенте
Процедура ДокументыПоКассеПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Копирование Тогда
		возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Параметр) Тогда
		возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	ИмяДокумента = РаботаСФормойДокументаКлиент.ПолучитьИмяДокументаПоТипу(Параметр);
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент(ИмяДокумента, "", ДанныеМеток, "ДокументыПоКассе");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОповещениеОбИзмененииДолга" Тогда
		Если ВариантОтображенияИтогов = ВедомостьЗаДень Тогда
			Подключаемый_ОбработатьАктивизациюСтрокиСписка();
		ИначеЕсли ВариантОтображенияИтогов <> НеОтображатьИтоги Тогда // Итоги по валюте (за период) и остаток в валюте.
			НастройкаИтоговЗавершениеНаСервере();
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "Запись_ПоступлениеВКассу" ИЛИ
		ИмяСобытия = "Запись_РасходИзКассы" Тогда
		Если Параметр.Свойство("УдалениеПомеченных") И Параметр.УдалениеПомеченных Тогда
			Возврат;
		КонецЕсли;
		Элементы.ДокументыПоКассе.ТекущаяСтрока = Параметр.Ссылка;
	КонецЕсли;
	
КонецПроцедуры // ОбработкаОповещения()

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Отборы
	// Банк и касса
	ПрочитатьРасчетныеСчетаИКассы();
	// Конец Отборы
	
	// Итоги
	НеОтображатьИтоги = Перечисления.ВариантыОтображенияИтоговБанкИКасса.НеОтображатьИтоги;
	ВедомостьЗаДень = Перечисления.ВариантыОтображенияИтоговБанкИКасса.ВедомостьЗаДень;
	ВедомостьЗаПериод = Перечисления.ВариантыОтображенияИтоговБанкИКасса.ВедомостьЗаПериод;
	
	Если НЕ ЗначениеЗаполнено(ВариантОтображенияИтогов) ИЛИ НЕ ПолучитьФункциональнуюОпцию("УчетВалютныхОпераций") Тогда
		ВариантОтображенияИтогов = ПредопределенноеЗначение("Перечисление.ВариантыОтображенияИтоговБанкИКасса.ВедомостьЗаДень");
		Если НЕ ПолучитьФункциональнуюОпцию("УчетВалютныхОпераций") Тогда
			Элементы.ДекорацияОткрытьФормуНастройкиИтогов.Видимость = Ложь;
			Элементы.ДекорацияОткрытьФормуНастройкиИтогов2.Видимость = Ложь;
			Элементы.ДекорацияОткрытьФормуНастройкиИтогов3.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьТаблицуИтогов();
	// Конец Итоги
	
	//УНФ.ОтборыСписка
	Если Параметры.Свойство("ЭтоНачальнаяСтраница") Тогда
		РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, ДокументыПоКассе, "ДокументыПоКассе");
		ЭтоНачальнаяСтраница = Ложь;
	Иначе
		ЭтоНачальнаяСтраница = Истина;
		РаботаСОтборами.СвернутьРазвернутьОтборыНаСервере(ЭтотОбъект, Ложь);
		ПредставлениеПериода = РаботаСОтборамиКлиентСервер.ОбновитьПредставлениеПериода(Неопределено);
	КонецЕсли;
	//Конец УНФ.ОтборыСписка
	
	// Установим формат для текущей даты: ДФ=Ч:мм
	УправлениеНебольшойФирмойСервер.УстановитьОформлениеКолонкиДата(ДокументыПоКассе);
	
	// МобильноеПриложение
	Если МобильноеПриложениеВызовСервера.НужноОграничитьФункциональность() Тогда
		Элементы.ПраваяПанель.Видимость = Ложь;
		Элементы.ФормаПоступлениеОтПоставщикаКасса.Видимость = Ложь;
		Элементы.ФормаПоступлениеПрочиеРасчетыКасса.Видимость = Ложь;
		Элементы.ФормаПоступлениеОтПодотчетникаКасса.Видимость = Ложь;
		Элементы.ФормаРасходПрочиеРачетыКасса.Видимость = Ложь;
		Элементы.ФормаРасходПокупателюКасса.Видимость = Ложь;
		Элементы.ФормаРасходПрочееКасса.Видимость = Ложь;
		Элементы.ФормаРасходПодотчетникуКасса.Видимость = Ложь;
		Элементы.ФормаРасходНалогиКасса.Видимость = Ложь;
		Элементы.ГруппаВажныеКоманды.Видимость = Ложь;
		Элементы.ФормаСоздатьПоШаблону.Видимость = Ложь;
		Элементы.ФормаОбработкаНастройкаПрограммыБольшеВозможностейКонтекст.Видимость = Ложь;
		Элементы.СписокКасса.Видимость = Ложь;
	КонецЕсли;
	// Конец МобильноеПриложение
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ ЗавершениеРаботы Тогда
		//УНФ.ОтборыСписка
		СохранитьНастройкиОтборов();
		//Конец УНФ.ОтборыСписка
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ВедомостьПерейти(Команда)
	
	ОткрытьФорму("Отчет.ДенежныеСредства.Форма", Новый Структура("КлючВарианта", "Ведомость"));
	
КонецПроцедуры // ВедомостьПерейти()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьПоШаблону(Команда)
	
	ЗаполнениеОбъектовУНФКлиент.ПоказатьВыборШаблонаДляСозданияДокументаИзСписка(ДокументыПоКассе, Элементы.ДокументыПоКассе.ТекущаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область Отборы

&НаСервере
Процедура ПрочитатьРасчетныеСчетаИКассы()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Кассы.Ссылка,
		|	ПРЕДСТАВЛЕНИЕ(Кассы.Ссылка) КАК Представление
		|ИЗ
		|	Справочник.Кассы КАК Кассы
		|
		|УПОРЯДОЧИТЬ ПО
		|	Кассы.Наименование";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаКасс = РезультатЗапроса.Выбрать();
	
	Элементы.ОтборСчетИКасса.СписокВыбора.Очистить();
	
	Пока ВыборкаКасс.Следующий() Цикл
		Элементы.ОтборСчетИКасса.СписокВыбора.Добавить(ВыборкаКасс.Ссылка);
	КонецЦикла;
	
КонецПроцедуры

#Область ОтборПоПериоду

// Процедура настривает период динамического списка (если требуется интерактивный выбор периода).
//
&НаКлиенте
Процедура УстановитьПериодЗавершение(Результат, Параметры) Экспорт
	
	УстановитьПериодЗавершениеНаСервере(Результат, Параметры);
	
КонецПроцедуры

// Процедура настривает период динамического списка на сервере (если требуется интерактивный выбор периода).
//
&НаСервере
Процедура УстановитьПериодЗавершениеНаСервере(Результат, Параметры)
	
	Если Результат <> Неопределено Тогда
		
		Элементы[Параметры.ИмяСписка].Период.Вариант = Результат.Вариант;
		Элементы[Параметры.ИмяСписка].Период.ДатаНачала = Результат.ДатаНачала;
		Элементы[Параметры.ИмяСписка].Период.ДатаОкончания = Результат.ДатаОкончания;
		Элементы[Параметры.ИмяСписка].Обновить();
		
		ВидПериодаЖурнала = ПолучитьПредставлениеПериода(Результат, " - ");
		
	КонецЕсли;
	
КонецПроцедуры

// Функция возвращает представление стандартного периода.
//
&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьПредставлениеПериода(СтандартныйПериод, Разделитель = " по ")
	
	ДатаНачала = СтандартныйПериод.ДатаНачала;
	ДатаОкончания = СтандартныйПериод.ДатаОкончания;
	Если Не ЗначениеЗаполнено(ДатаНачала) И Не ЗначениеЗаполнено(ДатаОкончания) Тогда
		Возврат "Интервал: <За все время>";
	ИначеЕсли СтандартныйПериод.Вариант <> ВариантСтандартногоПериода.ПроизвольныйПериод Тогда
		Возврат "Интервал: <" + СтандартныйПериод.Вариант + ">";
	ИначеЕсли Год(ДатаНачала) = Год(ДатаОкончания) И Месяц(ДатаНачала) = Месяц(ДатаОкончания) Тогда
		Возврат "Интервал: " + Формат(ДатаНачала, "ДФ=dd")+Разделитель+Формат(ДатаОкончания, "ДФ=dd.MM.yyyy");
	ИначеЕсли Год(ДатаНачала) = Год(ДатаОкончания) Тогда
		Возврат "Интервал: " + Формат(ДатаНачала, "ДФ=dd.MM")+Разделитель+Формат(ДатаОкончания, "ДФ=dd.MM.yyyy");
	Иначе
		Возврат "Интервал: " + Формат(ДатаНачала, "ДФ=dd.MM.yyyy")+Разделитель+Формат(ДатаОкончания, "ДФ=dd.MM.yyyy");
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ДИНАМИЧЕСКОГО СПИСКА

// Выбор значения отбора в поле отбора
&НаКлиенте
Процедура ОтборКонтрагентОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	УстановитьМеткуИОтборСписка("ДокументыПоКассе", "Контрагент", Элемент.Родитель.Имя, ВыбранноеЗначение);
	//Элемент.ОбновитьТекстРедактирования();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	УстановитьМеткуИОтборСписка("ДокументыПоКассе", "ОрганизацияДляОтбора", Элемент.Родитель.Имя, ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборВидОперацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Строка") Тогда
		УстановитьМеткуИОтборСписка("ДокументыПоКассе", "ВидОперации", Элемент.Родитель.Имя, "Перемещение. "+СокрЛП(ВыбранноеЗначение));
	Иначе
		УстановитьМеткуИОтборСписка("ДокументыПоКассе", "ВидОперации", Элемент.Родитель.Имя, ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСчетИКассаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	// НУЖНО ДОРАБОТАТЬ, чтобы для перемещения действовало условие ИЛИ для кассы и кассы получателя (тоже для РС)!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	УстановитьМеткуИОтборСписка("ДокументыПоКассе", "СчетКасса", Элемент.Родитель.Имя, ВыбранноеЗначение);
	//Элемент.ОбновитьТекстРедактирования();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборАвторОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	УстановитьМеткуИОтборСписка("ДокументыПоКассе", "Автор", Элемент.Родитель.Имя, ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборВидОперацииНачалоВыбораЗавершение(РезультатЗавершения, ПараметрыЗавершения) Экспорт
	
	Если ЗначениеЗаполнено(РезультатЗавершения) Тогда
		Если ТипЗнч(РезультатЗавершения) = Тип("Строка") Тогда
			СтандартнаяОбработка = Ложь;
			УстановитьМеткуИОтборСписка("ДокументыПоКассе", "ВидОперации", "ГруппаОтборВидОперации", "Перемещение. "+РезультатЗавершения);
		Иначе
			СтандартнаяОбработка = Ложь;
			УстановитьМеткуИОтборСписка("ДокументыПоКассе", "ВидОперации", "ГруппаОтборВидОперации", РезультатЗавершения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область МеткиОтборов

&НаСервере
Процедура УстановитьМеткуИОтборСписка(СписокДляОтбора, ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения="", ИмяПараметраЗапроса="")
	
	Если ПредставлениеЗначения="" Тогда
		ПредставлениеЗначения=Строка(ВыбранноеЗначение);
	КонецЕсли; 
	
	РаботаСОтборами.ПрикрепитьМеткуОтбора(ЭтотОбъект, ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения, СписокДляОтбора, ИмяПараметраЗапроса);
	
	Если ИмяПараметраЗапроса="" Тогда
		РаботаСОтборами.УстановитьОтборСписка(ЭтотОбъект, ЭтотОбъект[СписокДляОтбора], ИмяПоляОтбораСписка);
	Иначе	
		
		СтруктураОтбораМеток = Новый Структура("ИмяПараметраЗапроса", ИмяПараметраЗапроса);
		НайденныеСтроки = ДанныеМеток.НайтиСтроки(СтруктураОтбораМеток);
		МассивОтбора = Новый Массив;
		Для каждого стр Из НайденныеСтроки Цикл
			МассивОтбора.Добавить(стр.Метка);
		КонецЦикла;
		ЭтотОбъект[СписокДляОтбора].Параметры.УстановитьЗначениеПараметра("БезОтбора", НайденныеСтроки.Количество()=0);
		ЭтотОбъект[СписокДляОтбора].Параметры.УстановитьЗначениеПараметра(ИмяПараметраЗапроса, МассивОтбора);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_МеткаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МеткаИД = Сред(Элемент.Имя, СтрДлина("Метка_")+1);
	
	ИмяГруппыРодителя = СокрЛП(Элемент.Родитель.Имя);
	ИмяРеквизитаСписка = "ДокументыПоКассе";
	
	УдалитьМеткуОтбора(МеткаИД, ИмяРеквизитаСписка);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьМеткуОтбора(МеткаИД, ИмяРеквизитаСписка)
	
	РаботаСОтборами.УдалитьМеткуОтбораСервер(ЭтотОбъект, ЭтотОбъект[ИмяРеквизитаСписка], МеткаИД, ИмяРеквизитаСписка);

КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка)
	
	СтруктураИменЭлементов = Новый Структура("ОтборПериод, ПредставлениеПериода, СобытиеОповещения", "ОтборПериод", "ПредставлениеПериода", "ОповещениеОбИзмененииДолга");
	
	СтандартнаяОбработка = Ложь;
	РаботаСОтборамиКлиент.ПредставлениеПериодаВыбратьПериод(ЭтотОбъект, "ДокументыПоКассе", "Дата", СтруктураИменЭлементов);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиОтборов()
	
	Если НЕ ЭтоНачальнаяСтраница Тогда
		РаботаСОтборами.СохранитьНастройкиОтборов(ЭтотОбъект, "ДокументыПоКассе");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьРазвернутьПанельОтборов(Элемент)
	
	НовоеЗначениеВидимость = НЕ Элементы.ФильтрыНастройкиИДопИнфо.Видимость;
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость);
	
КонецПроцедуры

#КонецОбласти

#Область ПоступлениеВКассу

&НаКлиенте
Процедура ПоступлениеОтПокупателяКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("ПоступлениеВКассу", "ОтПокупателя", ДанныеМеток, "ДокументыПоКассе");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоступлениеПрочееКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("ПоступлениеВКассу", "Прочее", ДанныеМеток, "ДокументыПоКассе");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоступлениеОтПоставщикаКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("ПоступлениеВКассу", "ОтПоставщика", ДанныеМеток, "ДокументыПоКассе");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоступлениеПолучениеКредитаКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("ПоступлениеВКассу", "РасчетыПоКредитам", ДанныеМеток, "ДокументыПоКассе");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоступлениеВозвратЗаймаСотрудникомКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("ПоступлениеВКассу", "ВозвратЗаймаСотрудником", ДанныеМеток, "ДокументыПоКассе");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоступлениеПрочиеРасчетыКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("ПоступлениеВКассу", "ПрочиеРасчеты", ДанныеМеток, "ДокументыПоКассе");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоступлениеОтПодотчетникаКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("ПоступлениеВКассу", "ОтПодотчетника", ДанныеМеток, "ДокументыПоКассе");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоступлениеРозничнаяВыручкаКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("ПоступлениеВКассу", "РозничнаяВыручка", ДанныеМеток, "ДокументыПоКассе");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоступлениеРозничнаяВыручкаСуммовойУчетКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("ПоступлениеВКассу", "РозничнаяВыручкаСуммовойУчет", ДанныеМеток, "ДокументыПоКассе");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоступлениеПокупкаВалютыКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("ПоступлениеВКассу", "ПокупкаВалюты", ДанныеМеток, "ДокументыПоКассе");
	
КонецПроцедуры

#КонецОбласти

#Область РасходИзКассы

// Обработчик команды "РасходПрочиеРачетыКасса" формы.
//
&НаКлиенте
Процедура РасходПрочиеРачетыКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("РасходИзКассы", "ПрочиеРасчеты", ДанныеМеток, "ДокументыПоКассе");
	
КонецПроцедуры

&НаКлиенте
Процедура РасходНаРасходыКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("РасходИзКассы", "НаРасходы", ДанныеМеток, "ДокументыПоКассе");
	
КонецПроцедуры

&НаКлиенте
Процедура РасходПоставщикуКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("РасходИзКассы", "Поставщику", ДанныеМеток, "ДокументыПоКассе");
	
КонецПроцедуры

&НаКлиенте
Процедура РасходЗарплатаПоВедомостиКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("РасходИзКассы", "Зарплата", ДанныеМеток, "ДокументыПоКассе");
	
КонецПроцедуры

&НаКлиенте
Процедура РасходЗарплатаСотрудникуКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("РасходИзКассы", "ЗарплатаСотруднику", ДанныеМеток, "ДокументыПоКассе");
	
КонецПроцедуры

&НаКлиенте
Процедура РасходПокупателюКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("РасходИзКассы", "Покупателю", ДанныеМеток, "ДокументыПоКассе");
	
КонецПроцедуры

&НаКлиенте
Процедура РасходВозвратКредитаКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("РасходИзКассы", "РасчетыПоКредитам", ДанныеМеток, "ДокументыПоКассе");
	
КонецПроцедуры

&НаКлиенте
Процедура РасходВыдачаЗаймаКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("РасходИзКассы", "ВыдачаЗаймаСотруднику", ДанныеМеток, "ДокументыПоКассе");
	
КонецПроцедуры

&НаКлиенте
Процедура РасходПрочееКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("РасходИзКассы", "Прочее", ДанныеМеток, "ДокументыПоКассе");
	
КонецПроцедуры

&НаКлиенте
Процедура РасходПодотчетникуКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("РасходИзКассы", "Подотчетнику", ДанныеМеток, "ДокументыПоКассе");
	
КонецПроцедуры

&НаКлиенте
Процедура РасходПеремещениеВКассуККМКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("РасходИзКассы", "ПеремещениеВКассуККМ", ДанныеМеток, "ДокументыПоКассе");
	
КонецПроцедуры

&НаКлиенте
Процедура РасходНалогиКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("РасходИзКассы", "Налоги", ДанныеМеток, "ДокументыПоКассе");
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ЗаполнитьТаблицуИтогов()
	
	ТаблицаИтогов.Очистить();
	
	// Начальный остаток
	СтрокаИтогов = ТаблицаИтогов.Добавить();
	СтрокаИтогов.Показатель = "Начало дня";
	СтрокаИтогов.Значение = 0;
	
	// Начальный остаток
	СтрокаИтогов = ТаблицаИтогов.Добавить();
	СтрокаИтогов.Показатель = "Поступило";
	СтрокаИтогов.Значение = 0;
	
	// Начальный остаток
	СтрокаИтогов = ТаблицаИтогов.Добавить();
	СтрокаИтогов.Показатель = "Списано";
	СтрокаИтогов.Значение = 0;
	
	// Начальный остаток
	СтрокаИтогов = ТаблицаИтогов.Добавить();
	СтрокаИтогов.Показатель = "Конец дня";
	СтрокаИтогов.Значение = 0;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИнформациюОбИтогахПоВалюте()
	
	Если НЕ ОтборВалютаВедомости.Пустая() Тогда
		
		СтруктураДанные = ПолучитьДанныеПоВалюте(ОтборПериод, ОтборВалютаВедомости);
		
		ТаблицаИтогов[0].Значение = СтруктураДанные.ИнформацияСуммаВалНачальныйОстаток;
		ТаблицаИтогов[1].Значение = СтруктураДанные.ИнформацияСуммаВалПриход;
		ТаблицаИтогов[2].Значение = СтруктураДанные.ИнформацияСуммаВалРасход;
		ТаблицаИтогов[3].Значение = СтруктураДанные.ИнформацияСуммаВалКонечныйОстаток;
		
	Иначе
		ИнформацияСуммаВалКонечныйОстаток = 0;
		ИнформацияСуммаВалНачальныйОстаток = 0;
		ИнформацияСуммаВалПриход = 0;
		ИнформацияСуммаВалРасход = 0;
		Дата = "";
	Конецесли;
	
КонецПроцедуры // ОбработатьАктивизациюСтрокиСписка()

&НаСервереБезКонтекста
Функция ПолучитьДанныеПоВалюте(Период, Валюта)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДенежныеСредстваОстаткиИОбороты.СуммаВалНачальныйОстаток КАК ИнформацияСуммаВалНачальныйОстаток,
	|	ДенежныеСредстваОстаткиИОбороты.СуммаВалПриход КАК ИнформацияСуммаВалПриход,
	|	ДенежныеСредстваОстаткиИОбороты.СуммаВалРасход КАК ИнформацияСуммаВалРасход,
	|	ДенежныеСредстваОстаткиИОбороты.СуммаВалКонечныйОстаток КАК ИнформацияСуммаВалКонечныйОстаток
	|ИЗ
	|	РегистрНакопления.ДенежныеСредства.ОстаткиИОбороты(&НачалоПериода, &КонецПериода, , , Валюта = &Валюта) КАК ДенежныеСредстваОстаткиИОбороты";
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоДня(Период.ДатаНачала));
	Запрос.УстановитьПараметр("КонецПериода", ?(Период.ДатаОкончания = '00010101', '39991231', КонецДня(Период.ДатаОкончания)));
	Запрос.УстановитьПараметр("Валюта", Валюта);
	ВыборкаРезультата = Запрос.Выполнить().Выбрать();
	
	Если ВыборкаРезультата.Следующий() Тогда
		СтруктураВозврата = Новый Структура("ИнформацияСуммаВалНачальныйОстаток, ИнформацияСуммаВалКонечныйОстаток, ИнформацияСуммаВалПриход, ИнформацияСуммаВалРасход, УчетВалютныхОпераций, НомерБанковскогоСчета");
		ЗаполнитьЗначенияСвойств(СтруктураВозврата, ВыборкаРезультата);
		СтруктураВозврата.УчетВалютныхОпераций = ПолучитьФункциональнуюОпцию("УчетВалютныхОпераций");
		Возврат СтруктураВозврата;
	Иначе
		Возврат Новый Структура(
			"ИнформацияСуммаВалКонечныйОстаток, ИнформацияСуммаВалНачальныйОстаток, ИнформацияСуммаВалПриход, ИнформацияСуммаВалРасход, УчетВалютныхОпераций, НомерБанковскогоСчета",
			0,0,0,0,Ложь
		);
	КонецЕсли;
	
КонецФункции // ПолучитьДанныеПобанковскомуСчету()

&НаСервереБезКонтекста
Функция ПолучитьОстатокВВалюте(Валюта)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЕСТЬNULL(КурсыВалютСрезПоследних.Курс, 1) КАК Курс,
		|	ЕСТЬNULL(КурсыВалютСрезПоследних.Кратность, 1) КАК Кратность
		|ИЗ
		|	РегистрСведений.КурсыВалют.СрезПоследних(, Валюта = &Валюта) КАК КурсыВалютСрезПоследних";
	
	Запрос.УстановитьПараметр("Валюта", Валюта);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаПоВалюте = РезультатЗапроса.Выбрать();
	ВыборкаПоВалюте.Следующий();
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СУММА(ДенежныеСредстваОстатки.СуммаВалОстаток * ЕСТЬNULL(КурсыВалютСрезПоследних.Курс, 1) * &Кратность / (ЕСТЬNULL(КурсыВалютСрезПоследних.Кратность, 1) * &Курс)) КАК ОстатокВВалюте
		|ИЗ
		|	РегистрНакопления.ДенежныеСредства.Остатки(ДатаВремя(3999, 12, 31), ) КАК ДенежныеСредстваОстатки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(, ) КАК КурсыВалютСрезПоследних
		|		ПО ДенежныеСредстваОстатки.Валюта = КурсыВалютСрезПоследних.Валюта";
	
	Запрос.УстановитьПараметр("Валюта", Валюта);
	Запрос.УстановитьПараметр("Кратность", ВыборкаПоВалюте.Кратность);
	Запрос.УстановитьПараметр("Курс", ВыборкаПоВалюте.Курс);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	СтруктураВозврата = Новый Структура("Курс, Остаток", ВыборкаПоВалюте.Курс, 0);
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		СтруктураВозврата.Вставить("Остаток", ВыборкаДетальныеЗаписи.ОстатокВВалюте);
	КонецЕсли;
	
	Возврат СтруктураВозврата;
	
КонецФункции

&НаКлиенте
Процедура ДекорацияОткрытьФормуНастройкиИтоговНажатие(Элемент)
	
	НастройкаИтогов(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаИтогов(Команда)
	
	СтруктураПараметров = Новый Структура();
	
	СтруктураПараметров.Вставить("ВариантОтображенияИтогов", ВариантОтображенияИтогов);
	СтруктураПараметров.Вставить("ВалютаВедомости", ОтборВалютаВедомости);
	СтруктураПараметров.Вставить("ВалютаОстатков", ОтборВалютаОстатков);
	
	ОткрытьФорму("ОбщаяФорма.ФормаНастройкиИтоговБанкИКасса", 
		СтруктураПараметров, 
		ЭтотОбъект, 
		УникальныйИдентификатор,,,
		Новый ОписаниеОповещения("НастройкаИтоговЗавершение", ЭтотОбъект), 
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаИтоговЗавершение(РезультатЗавершения, ПараметрыЗавершения) Экспорт
	
	Если ТипЗнч(РезультатЗавершения) = Тип("Структура") Тогда
		
		ВариантОтображенияИтогов = РезультатЗавершения.ВариантОтображенияИтогов;
		ОтборВалютаВедомости = РезультатЗавершения.ВалютаВедомости;
		ОтборВалютаОстатков = РезультатЗавершения.ВалютаОстатков;
		
		НастройкаИтоговЗавершениеНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастройкаИтоговЗавершениеНаСервере() Экспорт
	
	Если ВариантОтображенияИтогов = ПредопределенноеЗначение("Перечисление.ВариантыОтображенияИтоговБанкИКасса.ВедомостьЗаДень") Тогда
		
		Элементы.ИнформацияСуммаВалНачальныйОстаток.Видимость = Истина;
		Элементы.ИнформацияСуммаВалПриход.Видимость = Истина;
		Элементы.ИнформацияСуммаВалРасход.Видимость = Истина;
		
		Элементы.ИнформацияСуммаВалНачальныйОстаток.Заголовок = "Начало дня";
		Элементы.ИнформацияСуммаВалКонечныйОстаток.Заголовок = "Конец дня";
		Элементы.ИнформацияСуммаВалКонечныйОстаток.Шрифт = Новый Шрифт(Элементы.ИнформацияСуммаВалКонечныйОстаток.Шрифт,,, Ложь);
		
		ТаблицаИтогов[0].Показатель = НСтр("ru = 'Начало дня'");
		ТаблицаИтогов[3].Показатель = НСтр("ru = 'Конец дня'");
		
		Элементы.СтраницаЗаДень.Видимость = Истина;
		Элементы.СтраницаЗаПериод.Видимость = Ложь;
		Элементы.СтраницаВВалюте.Видимость = Ложь;
		Элементы.СтраницаНеОтображатьИтоги.Видимость = Ложь;
		
		Элементы.Группа5.Видимость = Ложь;
		Элементы.ТаблицаИтогов.Видимость = Истина;
		
		Элементы.СтраницыИтоги.ТекущаяСтраница = Элементы.СтраницаЗаДень;
		
	ИначеЕсли ВариантОтображенияИтогов = ПредопределенноеЗначение("Перечисление.ВариантыОтображенияИтоговБанкИКасса.ВедомостьЗаПериод") Тогда
		
		ЗаполнитьИнформациюОбИтогахПоВалюте();
		
		//Элементы.ДекорацияВедомостьПоВалюте.Заголовок = НСтр("ru = 'Ведомость по валюте '")+""""+ОтборВалютаВедомости + """";
		Элементы.ДекорацияВедомостьПоВалюте.Заголовок = НСтр("ru = 'Ведомость по валюте: '")+ОтборВалютаВедомости;
		
		Элементы.ИнформацияСуммаВалНачальныйОстаток.Видимость = Истина;
		Элементы.ИнформацияСуммаВалПриход.Видимость = Истина;
		Элементы.ИнформацияСуммаВалРасход.Видимость = Истина;
		
		Элементы.ИнформацияСуммаВалНачальныйОстаток.Заголовок = "Начало периода";
		Элементы.ИнформацияСуммаВалКонечныйОстаток.Заголовок = "Конец периода";
		Элементы.ИнформацияСуммаВалКонечныйОстаток.Шрифт = Новый Шрифт(Элементы.ИнформацияСуммаВалКонечныйОстаток.Шрифт,,, Ложь);
		
		Если НЕ ЗначениеЗаполнено(ОтборПериод.ДатаНачала) И НЕ ЗначениеЗаполнено(ОтборПериод.ДатаОкончания) Тогда
			ТаблицаИтогов[0].Показатель = НСтр("ru = 'За все время'");
			ТаблицаИтогов[3].Показатель = НСтр("ru = 'Остаток'");
		Иначе
			ТаблицаИтогов[0].Показатель = НСтр("ru = 'С '")+Формат(ОтборПериод.ДатаНачала, "ДФ=dd.MM.yyyy");
			ТаблицаИтогов[3].Показатель = НСтр("ru = 'По '")+Формат(ОтборПериод.ДатаОкончания, "ДФ=dd.MM.yyyy");
		КонецЕсли;
		
		Элементы.СтраницаЗаДень.Видимость = Ложь;
		Элементы.СтраницаЗаПериод.Видимость = Истина;
		Элементы.СтраницаВВалюте.Видимость = Ложь;
		Элементы.СтраницаНеОтображатьИтоги.Видимость = Ложь;
		
		Элементы.Группа5.Видимость = Ложь;
		Элементы.ТаблицаИтогов.Видимость = Истина;
		
		Элементы.СтраницыИтоги.ТекущаяСтраница = Элементы.СтраницаЗаПериод;
		
	ИначеЕсли ВариантОтображенияИтогов = ПредопределенноеЗначение("Перечисление.ВариантыОтображенияИтоговБанкИКасса.ОстаткиПересчитанныеВВалюту") Тогда
		
		СтруктураДанных = ПолучитьОстатокВВалюте(ОтборВалютаОстатков);
		Элементы.ОтборКурс.Заголовок = НСтр("ru = 'Курс на '")+Формат(ТекущаяДатаСеанса(), "ДФ=dd.MM.yyyy")+"";
		ОтборКурс = ""+СтруктураДанных.Курс;
		ИнформацияСуммаВалКонечныйОстаток = СтруктураДанных.Остаток;
		Элементы.ДекорацияОстатокВВалюте.Заголовок = НСтр("ru = 'Остатки в валюте: '")+ОтборВалютаОстатков;
		
		Элементы.ИнформацияСуммаВалНачальныйОстаток.Видимость = Ложь;
		Элементы.ИнформацияСуммаВалПриход.Видимость = Ложь;
		Элементы.ИнформацияСуммаВалРасход.Видимость = Ложь;
		
		Элементы.ИнформацияСуммаВалКонечныйОстаток.Заголовок = НСтр("ru = 'Остаток'");
		
		Элементы.СтраницаЗаДень.Видимость = Ложь;
		Элементы.СтраницаЗаПериод.Видимость = Ложь;
		Элементы.СтраницаВВалюте.Видимость = Истина;
		Элементы.СтраницаНеОтображатьИтоги.Видимость = Ложь;
		
		Элементы.Группа5.Видимость = Истина;
		Элементы.ТаблицаИтогов.Видимость = Ложь;
		
		Элементы.СтраницыИтоги.ТекущаяСтраница = Элементы.СтраницаВВалюте;
		
	Иначе
		
		Элементы.СтраницаЗаДень.Видимость = Ложь;
		Элементы.СтраницаЗаПериод.Видимость = Ложь;
		Элементы.СтраницаВВалюте.Видимость = Ложь;
		Элементы.СтраницаНеОтображатьИтоги.Видимость = Истина;
		
		Элементы.Группа5.Видимость = Ложь;
		Элементы.ТаблицаИтогов.Видимость = Ложь;
		
		Элементы.СтраницыИтоги.ТекущаяСтраница = Элементы.СтраницаНеОтображатьИтоги;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияНастройкаВыводаИтоговНажатие(Элемент)
	
	НастройкаИтогов(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОстатокВВалютеНажатие(Элемент)
	
	//НастройкаИтогов(Неопределено);
	ПериодОтчета = Новый СтандартныйПериод;
	ПериодОтчета.ДатаНачала = ТекущаяДата();
	ПериодОтчета.ДатаОкончания = ТекущаяДата();
	ПараметрыОтчета = Новый Структура("СтПериод", ПериодОтчета);
	
	ОткрытьФорму("Отчет.ДенежныеСредства.Форма", Новый Структура("КлючВарианта, СформироватьПриОткрытии, Отбор", "ОстаткиВВалюте", Истина, ПараметрыОтчета));
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияВедомостьПоВалютеНажатие(Элемент)
	
	//НастройкаИтогов(Неопределено);
	ПараметрыОтчета = Новый Структура("СтПериод, Валюта", ОтборПериод, ОтборВалютаВедомости);
	ОткрытьФорму("Отчет.ДенежныеСредства.Форма", Новый Структура("КлючВарианта, СформироватьПриОткрытии, Отбор", "ВедомостьВВалюте", Истина, ПараметрыОтчета));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборВалютаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	УстановитьМеткуИОтборСписка("ДокументыПоКассе", "Валюта", Элемент.Родитель.Имя, ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборВидОперацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("ЖурналДокументов.ДокументыПоКассе.Форма.ФормаВыбораВидаОперации",,,,,, Новый ОписаниеОповещения("ОтборВидОперацииНачалоВыбораЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура Дата1Нажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элементы.ДокументыПоКассе.ТекущиеДанные <> Неопределено Тогда
		ПериодОтчета = Новый СтандартныйПериод;
		ПериодОтчета.ДатаНачала = Элементы.ДокументыПоКассе.ТекущиеДанные.Дата;
		ПериодОтчета.ДатаОкончания = Элементы.ДокументыПоКассе.ТекущиеДанные.Дата;
		ПараметрыОтчета = Новый Структура("СтПериод", ПериодОтчета);
	Иначе
		ПериодОтчета = Новый СтандартныйПериод;
		ПериодОтчета.ДатаНачала = '00010101';
		ПериодОтчета.ДатаОкончания = '00010101';
		ПараметрыОтчета = Новый Структура("СтПериод", ПериодОтчета);
	КонецЕсли;
	
	ОткрытьФорму("Отчет.ДенежныеСредства.Форма", Новый Структура("КлючВарианта, СформироватьПриОткрытии, Отбор", "ВедомостьВВалюте", Истина, ПараметрыОтчета));
	
КонецПроцедуры
