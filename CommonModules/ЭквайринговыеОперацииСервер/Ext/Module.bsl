﻿// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаДоходыИРасходыКассовыйМетодЭквайринг(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	// В этой процедуре нам нужно связать отложенную отгурзку и нераспределенную оплату 
	// на регистрах "ДоходыИРасходыКассовыйМетодЭквайринг" и "ДоходыИРасходыКассовыйМетод". В зависимости от того, оплачена эквайринговая операция или нет.
	
	Если Не СтруктураДополнительныеСвойства.УчетнаяПолитика.КассовыйМетодУчетаДоходовИРасходов Тогда
		СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДоходыИРасходыКассовыйМетодЭквайринг", Новый ТаблицаЗначений);
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	Запрос.УстановитьПараметр("КассовыйМетодУчетаДоходовИРасходов", СтруктураДополнительныеСвойства.УчетнаяПолитика.КассовыйМетодУчетаДоходовИРасходов);
	Запрос.УстановитьПараметр("МоментКонтроля", Новый Граница(СтруктураДополнительныеСвойства.ДляПроведения.МоментКонтроля, ВидГраницы.Включая));
	
	// Установка исключительной блокировки контролируемых остатков запасов.
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.Организация КАК Организация,
	|	ТаблицаДокумента.Документ КАК Документ,
	|	ТаблицаДокумента.Статья
	|ИЗ
	|	ВременнаяТаблицаПредоплата КАК ТаблицаДокумента
	|ГДЕ
	|	&КассовыйМетодУчетаДоходовИРасходов
	|	И ТаблицаДокумента.ЭтоЭквайринговаяОперация
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаДокумента.Организация,
	|	ТаблицаДокумента.Документ,
	|	ТаблицаДокумента.Статья";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ДоходыИРасходыКассовыйМетодЭквайринг");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = РезультатЗапроса;
	
	Для каждого КолонкаРезультатЗапроса из РезультатЗапроса.Колонки Цикл
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных(КолонкаРезультатЗапроса.Имя, КолонкаРезультатЗапроса.Имя);
	КонецЦикла;
	Блокировка.Заблокировать();
	
	// Получение остатков.
	ТаблицаДоходыИРасходыОтложенные = СтруктураДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДоходыИРасходыОтложенные.Скопировать();
	ТаблицаДоходыИРасходыОтложенные.Свернуть("Документ, НаправлениеДеятельности", "НеРаспределено");
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДоходыИРасходыКассовыйМетодЭквайрингОстатки.Документ КАК Документ,
	|	ДоходыИРасходыКассовыйМетодЭквайрингОстатки.Организация КАК Организация,
	|	ДоходыИРасходыКассовыйМетодЭквайрингОстатки.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ДоходыИРасходыКассовыйМетодЭквайрингОстатки.Статья КАК Статья,
	|	ДоходыИРасходыКассовыйМетодЭквайрингОстатки.СуммаДоходовОстаток КАК СуммаДоходовОстаток
	|ПОМЕСТИТЬ ДоходыИРасходыКассовыйМетодЭквайрингОстаткиОбъедиенние
	|ИЗ
	|	РегистрНакопления.ДоходыИРасходыКассовыйМетодЭквайринг.Остатки(
	|			&МоментКонтроля,
	|			НаправлениеДеятельности = ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка)
	|				И ВидОперацииЭквайринга = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийЭквайринга.ПоступлениеОплатыОтПокупателя)
	|				И (Организация, Документ, Статья) В
	|					(ВЫБРАТЬ
	|						ТаблицаДокумента.Организация КАК Организация,
	|						ТаблицаДокумента.Документ КАК Документ,
	|						ТаблицаДокумента.Статья
	|					ИЗ
	|						ВременнаяТаблицаПредоплата КАК ТаблицаДокумента
	|					ГДЕ
	|						&КассовыйМетодУчетаДоходовИРасходов
	|						И ТаблицаДокумента.ЭтоЭквайринговаяОперация)) КАК ДоходыИРасходыКассовыйМетодЭквайрингОстатки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДоходыИРасходыКассовыйМетодЭквайринг.Документ,
	|	ДоходыИРасходыКассовыйМетодЭквайринг.Организация,
	|	ДоходыИРасходыКассовыйМетодЭквайринг.НаправлениеДеятельности,
	|	ДоходыИРасходыКассовыйМетодЭквайринг.Статья,
	|	ВЫБОР
	|		КОГДА ДоходыИРасходыКассовыйМетодЭквайринг.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|			ТОГДА ЕСТЬNULL(ДоходыИРасходыКассовыйМетодЭквайринг.СуммаДоходов, 0)
	|		ИНАЧЕ -ЕСТЬNULL(ДоходыИРасходыКассовыйМетодЭквайринг.СуммаДоходов, 0)
	|	КОНЕЦ
	|ИЗ
	|	РегистрНакопления.ДоходыИРасходыКассовыйМетодЭквайринг КАК ДоходыИРасходыКассовыйМетодЭквайринг
	|ГДЕ
	|	ДоходыИРасходыКассовыйМетодЭквайринг.Регистратор = &Ссылка
	|	И ДоходыИРасходыКассовыйМетодЭквайринг.ВидОперацииЭквайринга = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийЭквайринга.ПоступлениеОплатыОтПокупателя)
	|	И ДоходыИРасходыКассовыйМетодЭквайринг.НаправлениеДеятельности = ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДоходыИРасходыКассовыйМетодЭквайрингОстаткиОбъедиенние.Документ,
	|	ДоходыИРасходыКассовыйМетодЭквайрингОстаткиОбъедиенние.Организация,
	|	ДоходыИРасходыКассовыйМетодЭквайрингОстаткиОбъедиенние.НаправлениеДеятельности,
	|	ДоходыИРасходыКассовыйМетодЭквайрингОстаткиОбъедиенние.Статья,
	|	СУММА(ДоходыИРасходыКассовыйМетодЭквайрингОстаткиОбъедиенние.СуммаДоходовОстаток) КАК СуммаДоходовОстаток
	|ПОМЕСТИТЬ ДоходыИРасходыКассовыйМетодЭквайрингОстатки
	|ИЗ
	|	ДоходыИРасходыКассовыйМетодЭквайрингОстаткиОбъедиенние КАК ДоходыИРасходыКассовыйМетодЭквайрингОстаткиОбъедиенние
	|
	|СГРУППИРОВАТЬ ПО
	|	ДоходыИРасходыКассовыйМетодЭквайрингОстаткиОбъедиенние.Документ,
	|	ДоходыИРасходыКассовыйМетодЭквайрингОстаткиОбъедиенние.Организация,
	|	ДоходыИРасходыКассовыйМетодЭквайрингОстаткиОбъедиенние.НаправлениеДеятельности,
	|	ДоходыИРасходыКассовыйМетодЭквайрингОстаткиОбъедиенние.Статья
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДокумента.Организация КАК Организация,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ТаблицаДокумента.Период КАК Период,
	|	ТаблицаДокумента.Документ КАК ДокументПредоплаты,
	|	СУММА(ТаблицаДокумента.Сумма) КАК СуммаКСписанию,
	|	СУММА(ЕСТЬNULL(ДоходыИРасходыКассовыйМетодЭквайрингОстатки.СуммаДоходовОстаток, 0)) КАК СуммаДоходовОстаток,
	|	ТаблицаДокумента.Статья,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыОперацийЭквайринга.ПоступлениеОплатыОтПокупателя) КАК ВидОперацииЭквайринга
	|ИЗ
	|	ВременнаяТаблицаПредоплата КАК ТаблицаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ДоходыИРасходыКассовыйМетодЭквайрингОстатки КАК ДоходыИРасходыКассовыйМетодЭквайрингОстатки
	|		ПО ТаблицаДокумента.Организация = ДоходыИРасходыКассовыйМетодЭквайрингОстатки.Организация
	|			И ТаблицаДокумента.Документ = ДоходыИРасходыКассовыйМетодЭквайрингОстатки.Документ
	|			И ТаблицаДокумента.Статья = ДоходыИРасходыКассовыйМетодЭквайрингОстатки.Статья
	|ГДЕ
	|	&КассовыйМетодУчетаДоходовИРасходов
	|	И ТаблицаДокумента.ЭтоЭквайринговаяОперация
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаДокумента.Организация,
	|	ТаблицаДокумента.Период,
	|	ТаблицаДокумента.Документ,
	|	ТаблицаДокумента.Статья";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаРезультатаЗапроса = РезультатЗапроса.Выбрать();
	
	ТаблицаПредоплатаДоходыИРасходыОтложенныеЭквайринг = РегистрыНакопления.ДоходыИРасходыКассовыйМетодЭквайринг.СоздатьНаборЗаписей().ВыгрузитьКолонки();
	ТаблицаПредоплатаДоходыИРасходыОтложенныеЭквайринг.Очистить();
	
	ТаблицаПредоплатаДоходыИРасходыОтложенныеЭквайринг.Колонки.Удалить("Активность");
	
	ТаблицаПредоплатаДоходыИРасходыОтложенные = ТаблицаПредоплатаДоходыИРасходыОтложенныеЭквайринг.Скопировать();
	
	ТаблицаЭквайрингСторно = ТаблицаПредоплатаДоходыИРасходыОтложенныеЭквайринг.Скопировать();
	ТаблицаСторно = ТаблицаПредоплатаДоходыИРасходыОтложенныеЭквайринг.Скопировать();
	
	ТаблицаПредоплатаДоходыИРасходыОтложенныеЭквайринг.Колонки.Удалить("Документ");
	ТаблицаПредоплатаДоходыИРасходыОтложенныеЭквайринг.Колонки.Добавить("Документ");
	
	ТаблицаСторно.Колонки.Добавить("ДокументПредоплаты");
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДоходыИРасходыОтложенные.Колонки.Добавить("ДокументПредоплаты");
	
	ТаблицаПредоплатаДоходыИРасходыОтложенные.Колонки.Удалить("Документ");
	ТаблицаПредоплатаДоходыИРасходыОтложенные.Колонки.Добавить("Документ");
	ТаблицаПредоплатаДоходыИРасходыОтложенные.Колонки.Добавить("ДокументПредоплаты");
	
	НеРаспределено = ТаблицаДоходыИРасходыОтложенные.Итог("НеРаспределено");
	
	Пока ВыборкаРезультатаЗапроса.Следующий() И НеРаспределено > 0 Цикл
		
		СуммаКСписаниюВБуферномРегистре = ВыборкаРезультатаЗапроса.СуммаДоходовОстаток;
		СуммаКСписаниюПоДоходамИРаскодамКМ = ВыборкаРезультатаЗапроса.СуммаКСписанию - СуммаКСписаниюВБуферномРегистре;
		
		// Необходимо распределить оставшуюся сумму отгрузки между двумя регистрами.
		// В первую очередь требуется распределять по уже оплаченным банком платежным картам, т.е. выполнять
		// движения по регистру ДоходыИРасходыКассовыйМетод.
		
		// Цикл №1. Зачесть сумму СуммаКСписаниюПоДоходамИРаскодамКМ.
		Если СуммаКСписаниюПоДоходамИРаскодамКМ > 0 Тогда
			СуммаКСписанию = СуммаКСписаниюПоДоходамИРаскодамКМ;
			ТекущаяТаблица = ТаблицаПредоплатаДоходыИРасходыОтложенные;
			ТекущаяТаблицаСторно = ТаблицаСторно;
			
			Для каждого СтрокаЗапасыДоходыИРасходыОтложенные Из ТаблицаДоходыИРасходыОтложенные Цикл
				Если СуммаКСписанию = 0 Или СтрокаЗапасыДоходыИРасходыОтложенные.НеРаспределено <= 0 Тогда
					Продолжить
				ИначеЕсли СтрокаЗапасыДоходыИРасходыОтложенные.НеРаспределено <= СуммаКСписанию Тогда
					Списать = СтрокаЗапасыДоходыИРасходыОтложенные.НеРаспределено;
					СуммаКСписанию = СуммаКСписанию - Списать;
					СтрокаЗапасыДоходыИРасходыОтложенные.НеРаспределено = 0;
				ИначеЕсли СтрокаЗапасыДоходыИРасходыОтложенные.НеРаспределено > СуммаКСписанию Тогда
					Списать = СуммаКСписанию;
					СуммаКСписанию = 0;
					СтрокаЗапасыДоходыИРасходыОтложенные.НеРаспределено = СтрокаЗапасыДоходыИРасходыОтложенные.НеРаспределено - Списать;
				КонецЕсли;
				
				НеРаспределено = НеРаспределено - Списать;
				
				НоваяСтрока = ТекущаяТаблицаСторно.Добавить();
				НоваяСтрока.ВидДвижения = ВидДвиженияНакопления.Приход;
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаРезультатаЗапроса);
				НоваяСтрока.ДокументПредоплаты = ВыборкаРезультатаЗапроса.ДокументПредоплаты;
				НоваяСтрока.СуммаДоходов = -Списать;
				НоваяСтрока.Период = СтруктураДополнительныеСвойства.ДляПроведения.МоментВремени.Дата;
				
				НоваяСтрока = ТекущаяТаблица.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаРезультатаЗапроса);
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗапасыДоходыИРасходыОтложенные, "Документ, НаправлениеДеятельности");
				НоваяСтрока.СуммаДоходов = Списать;
				НоваяСтрока.ДокументПредоплаты = ВыборкаРезультатаЗапроса.ДокументПредоплаты;
				
				// Добавим записи в регистр "ДоходыИРасходыНераспределенные".
				НоваяСтрока = СтруктураДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДоходыИРасходыНераспределенные.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаРезультатаЗапроса);
				НоваяСтрока.Документ = ВыборкаРезультатаЗапроса.ДокументПредоплаты;
				НоваяСтрока.ВидДвижения = ВидДвиженияНакопления.Расход;
				НоваяСтрока.СуммаДоходов = Списать;
			КонецЦикла;
		КонецЕсли;
		
		// Цикл №2. Зачесть сумму СуммаКСписаниюВБуферномРегистре.
		Если СуммаКСписаниюВБуферномРегистре > 0 И НеРаспределено > 0 Тогда
			СуммаКСписанию = СуммаКСписаниюВБуферномРегистре;
			ТекущаяТаблица = ТаблицаПредоплатаДоходыИРасходыОтложенныеЭквайринг;
			ТекущаяТаблицаСторно = ТаблицаЭквайрингСторно;
			
			Для каждого СтрокаЗапасыДоходыИРасходыОтложенные Из ТаблицаДоходыИРасходыОтложенные Цикл
				Если СуммаКСписанию = 0 Или СтрокаЗапасыДоходыИРасходыОтложенные.НеРаспределено <= 0 Тогда
					Продолжить
				ИначеЕсли СтрокаЗапасыДоходыИРасходыОтложенные.НеРаспределено <= СуммаКСписанию Тогда
					Списать = СтрокаЗапасыДоходыИРасходыОтложенные.НеРаспределено;
					СуммаКСписанию = СуммаКСписанию - Списать;
					СтрокаЗапасыДоходыИРасходыОтложенные.НеРаспределено = 0;
				ИначеЕсли СтрокаЗапасыДоходыИРасходыОтложенные.НеРаспределено > СуммаКСписанию Тогда
					Списать = СуммаКСписанию;
					СуммаКСписанию = 0;
					СтрокаЗапасыДоходыИРасходыОтложенные.НеРаспределено = СтрокаЗапасыДоходыИРасходыОтложенные.НеРаспределено - Списать;
				КонецЕсли;
				
				НеРаспределено = НеРаспределено - Списать;
				
				НоваяСтрока = ТекущаяТаблицаСторно.Добавить();
				НоваяСтрока.ВидДвижения = ВидДвиженияНакопления.Приход;
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаРезультатаЗапроса);
				НоваяСтрока.Документ = ВыборкаРезультатаЗапроса.ДокументПредоплаты;
				НоваяСтрока.СуммаДоходов = -Списать;
				НоваяСтрока.Период = СтруктураДополнительныеСвойства.ДляПроведения.МоментВремени.Дата;
				
				// Добавим записи в регистр "ДоходыИРасходыОтложенные".
				НоваяСтрока = СтруктураДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДоходыИРасходыОтложенные.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаРезультатаЗапроса);
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗапасыДоходыИРасходыОтложенные, "Документ, НаправлениеДеятельности");
				НоваяСтрока.ДокументПредоплаты = ВыборкаРезультатаЗапроса.ДокументПредоплаты;
				НоваяСтрока.ВидДвижения = ВидДвиженияНакопления.Расход;
				НоваяСтрока.СуммаДоходов = Списать;
				
				// Добавим записи в регистр "ТаблицаДоходыИРасходыКассовыйМетодЭквайринг".
				НоваяСтрока = ТекущаяТаблица.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаРезультатаЗапроса);
				НоваяСтрока.НаправлениеДеятельности = СтрокаЗапасыДоходыИРасходыОтложенные.НаправлениеДеятельности;
				НоваяСтрока.Документ = ВыборкаРезультатаЗапроса.ДокументПредоплаты;
				НоваяСтрока.СуммаДоходов = Списать;
				
				// Добавим записи в регистр "ДоходыИРасходыНераспределенные".
				НоваяСтрока = СтруктураДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДоходыИРасходыНераспределенные.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаРезультатаЗапроса);
				НоваяСтрока.Документ = ВыборкаРезультатаЗапроса.ДокументПредоплаты;
				НоваяСтрока.ВидДвижения = ВидДвиженияНакопления.Расход;
				НоваяСтрока.СуммаДоходов = Списать;
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
	
	// Добавим записи в регистр "ДоходыИРасходыОтложенные".
	Для каждого ТекущаяСтрока Из ТаблицаПредоплатаДоходыИРасходыОтложенные Цикл
		НоваяСтрока = СтруктураДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДоходыИРасходыОтложенные.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
		НоваяСтрока.ВидДвижения = ВидДвиженияНакопления.Расход;
	КонецЦикла;
	
	// Сторнируем записи в регистрах "ДоходыИРасходыКассовыйМетодЭквайринг" и "ДоходыИРасходыКассовыйМетод".
	Для каждого ТекущаяСтрокаСторно Из ТаблицаЭквайрингСторно Цикл
		НоваяСтрока = ТаблицаПредоплатаДоходыИРасходыОтложенныеЭквайринг.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрокаСторно);
	КонецЦикла;
	Для каждого ТекущаяСтрокаСторно Из ТаблицаСторно Цикл
		НоваяСтрока = ТаблицаПредоплатаДоходыИРасходыОтложенные.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрокаСторно);
	КонецЦикла;
	
	// Добавим записи в регистры "ДоходыИРасходыКассовыйМетодЭквайринг" и "ДоходыИРасходыКассовыйМетод".
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДоходыИРасходыКассовыйМетодЭквайринг", ТаблицаПредоплатаДоходыИРасходыОтложенныеЭквайринг);
	Если СтруктураДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДоходыИРасходыКассовыйМетод.Количество() = 0 Тогда
		СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДоходыИРасходыКассовыйМетод", ТаблицаПредоплатаДоходыИРасходыОтложенные.СкопироватьКолонки());
	КонецЕсли;
	
	Если СтруктураДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДоходыИРасходыКассовыйМетод.Колонки.Найти("Документ") = Неопределено Тогда
		СтруктураДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДоходыИРасходыКассовыйМетод.Колонки.Добавить("Документ");
	КонецЕсли;
	Для каждого ТекущаяСтрока Из ТаблицаПредоплатаДоходыИРасходыОтложенные Цикл
		НоваяСтрока = СтруктураДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДоходыИРасходыКассовыйМетод.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
		НоваяСтрока.Документ = ТекущаяСтрока.ДокументПредоплаты;
	КонецЦикла;
	
КонецПроцедуры // СформироватьТаблицаДоходыИРасходыКассовыйМетод()
