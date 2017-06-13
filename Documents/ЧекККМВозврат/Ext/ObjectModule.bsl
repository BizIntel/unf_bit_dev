﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура заполнения документа на основании расходного кассового ордера.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа
//	
Процедура ЗаполнитьПоЧекуККМ(ДанныеЗаполнения) Экспорт
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("ДокументСсылка.ЧекККМ") Тогда
		
		ВызватьИсключение НСтр("ru = 'Чеки ККМ на возврат должны вводиться на основании чеков ККМ'");
		
	КонецЕсли;
	
	// Заполним данные шапки документа.
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ЧекККМ.ВалютаДокумента КАК ВалютаДокумента,
	|	ЧекККМ.Ссылка КАК ЧекККМ,
	|	ЧекККМ.ВидЦен КАК ВидЦен,
	|	ЧекККМ.ВидСкидкиНаценки КАК ВидСкидкиНаценки,
	|	ЧекККМ.Организация КАК Организация,
	|	ЧекККМ.НалогообложениеНДС КАК НалогообложениеНДС,
	|	ЧекККМ.КассаККМ КАК КассаККМ,
	|	ЧекККМ.КассоваяСмена КАК КассоваяСмена,
	|	ЧекККМ.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ЧекККМ.Подразделение КАК Подразделение,
	|	ЧекККМ.Ответственный КАК Ответственный,
	|	ЧекККМ.СуммаДокумента КАК СуммаДокумента,
	|	ЧекККМ.СуммаВключаетНДС КАК СуммаВключаетНДС,
	|	ЧекККМ.НДСВключатьВСтоимость КАК НДСВключатьВСтоимость,
	|	ЧекККМ.ЭквайринговыйТерминал КАК ЭквайринговыйТерминал,
	|	ЧекККМ.ДисконтнаяКарта КАК ДисконтнаяКарта,
	|	ЧекККМ.ПроцентСкидкиПоДисконтнойКарте КАК ПроцентСкидкиПоДисконтнойКарте,
	|	ЧекККМ.Запасы.(
	|		Номенклатура,
	|		Характеристика,
	|		Партия,
	|		Количество,
	|		ЕдиницаИзмерения,
	|		Цена,
	|		ПроцентСкидкиНаценки,
	|		Сумма,
	|		СтавкаНДС,
	|		СуммаНДС,
	|		Всего,
	|		ПроцентАвтоматическойСкидки,
	|		СуммаАвтоматическойСкидки,
	|		КлючСвязи,
	|		Заказ,
	|		СерийныеНомера,
	|		КлючСвязи КАК КлючСвязи1
	|	) КАК Запасы,
	|	ЧекККМ.ОплатаПлатежнымиКартами.(
	|		ВидПлатежнойКарты,
	|		НомерПлатежнойКарты,
	|		Сумма,
	|		СсылочныйНомер,
	|		НомерЧекаЭТ
	|	) КАК ОплатаПлатежнымиКартами,
	|	ЧекККМ.НомерЧекаККМ,
	|	ЧекККМ.Проведен,
	|	ЧекККМ.СкидкиНаценки.(
	|		Ссылка,
	|		НомерСтроки,
	|		КлючСвязи,
	|		СкидкаНаценка,
	|		Сумма
	|	),
	|	ЧекККМ.СкидкиРассчитаны,
	|	ЧекККМ.АкцизныеМарки.(
	|		Ссылка,
	|		НомерСтроки,
	|		КлючСвязи,
	|		КодАкцизнойМарки
	|	) КАК АкцизныеМарки,
	|	ЧекККМ.ПоложениеЗаказаПокупателя,
	|	ЧекККМ.Заказ,
	|	ЧекККМ.Контрагент
	|ИЗ
	|	Документ.ЧекККМ КАК ЧекККМ
	|ГДЕ
	|	ЧекККМ.Ссылка = &Ссылка";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка, ,"НомерЧекаККМ, Проведен");
	
	ТекстОшибки = "";
	
	Если НЕ РозничныеПродажиСервер.СменаОткрыта(Выборка.КассоваяСмена, ТекущаяДата(), ТекстОшибки) Тогда
		
		ТекстОшибки = ТекстОшибки + НСтр("ru='. Ввод на основании невозможен'");
		
		ВызватьИсключение ТекстОшибки;
		
	КонецЕсли;
	
	Если НЕ Выборка.Проведен Тогда
		
		ТекстОшибки = НСтр("ru='Чек ККМ не проведен. Ввод на основании невозможен'");
		
		ВызватьИсключение ТекстОшибки;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Выборка.НомерЧекаККМ) Тогда
		
		ТекстОшибки = НСтр("ru='Чек ККМ не пробит. Ввод на основании невозможен'");
	
		ВызватьИсключение ТекстОшибки;
		
	КонецЕсли;
	
	ЭтотОбъект.Запасы.Загрузить(Выборка.Запасы.Выгрузить());
	ЭтотОбъект.ОплатаПлатежнымиКартами.Загрузить(Выборка.ОплатаПлатежнымиКартами.Выгрузить());
	
	РаботаССерийнымиНомерами.ЗаполнитьТЧСерийныеНомераПоКлючуСвязи(ЭтотОбъект, ДанныеЗаполнения);
	
	// АвтоматическиеСкидки
	Если ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическиеСкидкиНаценки") Тогда
		ЭтотОбъект.СкидкиНаценки.Загрузить(Выборка.СкидкиНаценки.Выгрузить());
	КонецЕсли;
	// Конец АвтоматическиеСкидки
	
	ЭтотОбъект.АкцизныеМарки.Загрузить(Выборка.АкцизныеМарки.Выгрузить());
	
КонецПроцедуры // ЗаполнитьПоРасходномуКассовомуОрдеру()

// Добавляет дополнительные реквизиты, необходимые для проведения документа в
// переданную структуру.
//
// Параметры:
//  СтруктураДополнительныеСвойства - Структура дополнительных свойств документа.
//
Процедура ДобавитьРеквизитыВДополнительныеСвойстваДляПроведения(СтруктураДополнительныеСвойства)
	
	СтруктураДополнительныеСвойства.ДляПроведения.Вставить("ЧекПробит", ЗначениеЗаполнено(НомерЧекаККМ));
	СтруктураДополнительныеСвойства.ДляПроведения.Вставить("Архивный", Архивный);
	СтруктураДополнительныеСвойства.ДляПроведения.Вставить("ДвиженияПоЗапасамУдалять", ДвиженияПоЗапасамУдалять);
	
КонецПроцедуры // ДобавитьРеквизитыВДополнительныеСвойстваДляПроведения()

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события "При копировании".
//
Процедура ПриКопировании(ОбъектКопирования)
	
	ВызватьИсключение НСтр("ru = 'Чек на возврат вводится только на основании'");
	
КонецПроцедуры // ПриКопировании()

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, "ЗаполнитьПоЧекуККМ", "Контрагент");
	
КонецПроцедуры // ОбработкаЗаполнения()

// Процедура - обработчик события "Обработка проверки заполнения".
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЧекККМВозврат.Ссылка
	|ИЗ
	|	Документ.ЧекККМВозврат КАК ЧекККМВозврат
	|ГДЕ
	|	ЧекККМВозврат.Ссылка <> &Ссылка
	|	И ЧекККМВозврат.Проведен
	|	И ЧекККМВозврат.ЧекККМ = &ЧекККМ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЧекККМ.КассоваяСмена КАК КассоваяСмена,
	|	ЧекККМ.Дата КАК Дата,
	|	ЧекККМ.Проведен КАК Проведен,
	|	ЧекККМ.НомерЧекаККМ КАК НомерЧекаККМ
	|ИЗ
	|	Документ.ЧекККМ КАК ЧекККМ
	|ГДЕ
	|	ЧекККМ.Ссылка = &ЧекККМ";
	
	Запрос.УстановитьПараметр("ЧекККМ", ЧекККМ);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Результат = Запрос.ВыполнитьПакет();
	Выборка = Результат[0].Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ТекстОшибки = НСтр("ru='Для данного чека уже введен чек на возврат'");
		
		УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
			ЭтотОбъект,
			ТекстОшибки,
			Неопределено,
			Неопределено,
			"ЧекККМ",
			Отказ
		); 
		
	КонецЦикла;
	
	Выборка = Результат[1].Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если НачалоДня(Выборка.Дата) <> НачалоДня(Дата) Тогда
			
			ТекстОшибки = НСтр("ru='Дата чека на возврат должна соответствовать дате чека продажи'");
			
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстОшибки,
				Неопределено,
				Неопределено,
				"Дата",
				Отказ
			); 

		КонецЕсли;
		
		Если КассоваяСмена <> Выборка.КассоваяСмена Тогда
			
			ТекстОшибки = НСтр("ru='Кассовая смена Чека на возврат должна соответствовать кассовой смене чека продажи'");
			
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстОшибки,
				Неопределено,
				Неопределено,
				"КассоваяСмена",
				Отказ
			); 

		КонецЕсли;
		
		Если НЕ Выборка.Проведен Тогда
			
			ТекстОшибки = НСтр("ru='Чек ККМ не проведен'");
			
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстОшибки,
				Неопределено,
				Неопределено,
				"ЧекККМ",
				Отказ
			); 

		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Выборка.НомерЧекаККМ) Тогда
			
			ТекстОшибки = НСтр("ru='Чек ККМ продажи не пробит'");
			
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстОшибки,
				Неопределено,
				Неопределено,
				"ЧекККМ",
				Отказ
			);
			
		КонецЕсли;
		
		ТекстОшибки = НСтр("ru='Кассовая смена не открыта'");
		Если НЕ РозничныеПродажиСервер.СменаОткрыта(КассоваяСмена, Дата, ТекстОшибки) Тогда
			
			
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстОшибки,
				Неопределено,
				Неопределено,
				"КассоваяСмена",
				Отказ
			);

		КонецЕсли;
		
	КонецЦикла;
	
	Если ОплатаПлатежнымиКартами.Количество() > 0 И НЕ ЗначениеЗаполнено(ЭквайринговыйТерминал) Тогда
		
		ТекстОшибки = НСтр("ru='Поле ""Эквайринговый терминал"" не заполнено'");
		
		УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
			ЭтотОбъект,
			ТекстОшибки,
			Неопределено,
			Неопределено,
			"ЭквайринговыйТерминал",
			Отказ
		);
		
	КонецЕсли;
	
	// Скидка 100%.
	ЕстьРучныеСкидки = ПолучитьФункциональнуюОпцию("ИспользоватьРучныеСкидкиНаценкиПродажи");
	ЕстьАвтоматическиеСкидки = ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическиеСкидкиНаценки"); // АвтоматическиеСкидки
	Если ЕстьРучныеСкидки ИЛИ ЕстьАвтоматическиеСкидки Тогда
		Для каждого СтрокаЗапасы Из Запасы Цикл
			// АвтоматическиеСкидки
			ТекСумма = СтрокаЗапасы.Цена * СтрокаЗапасы.Количество;
			ТекСуммаРучнойСкидки = ?(ЕстьРучныеСкидки, ОКР(ТекСумма * СтрокаЗапасы.ПроцентСкидкиНаценки / 100, 2), 0);
			ТекСуммаАвтоматическойСкидки = ?(ЕстьАвтоматическиеСкидки, СтрокаЗапасы.СуммаАвтоматическойСкидки, 0);
			ТекСуммаСкидки = ТекСуммаРучнойСкидки + ТекСуммаАвтоматическойСкидки;
			Если СтрокаЗапасы.ПроцентСкидкиНаценки <> 100 И ТекСуммаСкидки < ТекСумма
				И НЕ ЗначениеЗаполнено(СтрокаЗапасы.Сумма) Тогда
				ТекстСообщения = НСтр("ru = 'Не заполнена колонка ""Сумма"" в строке %Номер% списка ""Запасы"".'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Номер%", СтрокаЗапасы.НомерСтроки);
				УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
					ЭтотОбъект,
					ТекстСообщения,
					"Запасы",
					СтрокаЗапасы.НомерСтроки,
					"Сумма",
					Отказ
				);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Серийные номера
	РаботаССерийнымиНомерами.ПроверкаЗаполненияСерийныхНомеров(Отказ, Запасы, СерийныеНомера, СтруктурнаяЕдиница, ЭтотОбъект);
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Процедура - обработчик события "ПередЗаписью".
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НомерЧекаККМ)
	   И РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения
	   И НЕ КассаККМ.ИспользоватьБезПодключенияОборудования Тогда
		
		Отказ = Истина;
		
		ТекстОшибки = НСтр("ru='Чек ККМ на возврат пробит на фискальном регистраторе. Отмена проведения невозможна'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект);
			
		Возврат;
		
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения
	   И КассаККМ.ИспользоватьБезПодключенияОборудования
	   И КассоваяСмена.Проведен
	   И КассоваяСмена.СтатусКассовойСмены = Перечисления.СтатусыОтчетаОРозничныхПродажах.Закрыта Тогда
		
		ТекстСообщения = НСтр("ru='Кассовая смена закрыта. Отмена проведения невозможна'");
		
		УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				,
				,
				,
				Отказ
			);
		
		Возврат;
		
	КонецЕсли;
	
	// Заказы покупателей в розничной торговле
	Если ПоложениеЗаказаПокупателя = Перечисления.ПоложениеРеквизитаНаФорме.ВШапке Тогда
		Для каждого СтрокаТабличнойЧасти Из Запасы Цикл
			СтрокаТабличнойЧасти.Заказ = ?(ЗначениеЗаполнено(Заказ), Заказ, Неопределено);
		КонецЦикла;
		ЕстьЗаказы = НЕ Заказ.Пустая();
	КонецЕсли;
	
	Если НЕ ЕстьЗаказы Тогда
		Для каждого СтрокаТабличнойЧасти Из Запасы Цикл
			Если НЕ СтрокаТабличнойЧасти.Заказ.Пустая() Тогда
				ЕстьЗаказы = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	// Конец Заказы покупателей в розничной торговле
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события "ОбработкаПроведения".
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	ДобавитьРеквизитыВДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.ЧекККМВозврат.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	УправлениеНебольшойФирмойСервер.ОтразитьЗапасы(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьЗапасыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДенежныеСредстваВКассахККМ(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДоходыИРасходы(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьПродажи(ДополнительныеСвойства, Движения, Отказ);
	
	// ДисконтныеКарты
	УправлениеНебольшойФирмойСервер.ОтразитьПродажиПоДисконтнойКарте(ДополнительныеСвойства, Движения, Отказ);
	// АвтоматическиеСкидки
	УправлениеНебольшойФирмойСервер.ОтразитьПредоставленныеАвтоматическиеСкидки(ДополнительныеСвойства, Движения, Отказ);
	// Эквайринг
	УправлениеНебольшойФирмойСервер.ОтразитьОплатаПлатежнымиКартами(ДополнительныеСвойства, Движения, Отказ);
	// Заказы покупателей в розничной торговле
	УправлениеНебольшойФирмойСервер.ОтразитьЗаказыПокупателей(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьОплатаСчетовИЗаказов(ДополнительныеСвойства, Движения, Отказ);
	
	УправлениеНебольшойФирмойСервер.ОтразитьУправленческий(ДополнительныеСвойства, Движения, Отказ);
	
	// СерийныеНомера
	УправлениеНебольшойФирмойСервер.ОтразитьСерийныеНомераГарантии(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьСерийныеНомераОстатки(ДополнительныеСвойства, Движения, Отказ);
		
	// Запись наборов записей.
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательного остатка.
	Документы.ЧекККМВозврат.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);

	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры // ОбработкаПроведения()

// Процедура - обработчик события "ОбработкаУдаленияПроведения".
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательного остатка.
	Документы.ЧекККМВозврат.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);
	
КонецПроцедуры // ОбработкаУдаленияПроведения()

#КонецОбласти

#КонецЕсли