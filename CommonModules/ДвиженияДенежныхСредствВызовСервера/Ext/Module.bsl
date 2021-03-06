﻿Функция ПолучитьНовоеЗначениеСтатьиДДССписания(ВидОперацииПрочееСписание, СтатьяДДС, СтатьяДДСВходящий, СтатьяДДСИсходящий) Экспорт
	
	НоваяСтатьяДДС = СтатьяДДС;
	
	Если (СтатьяДДС = ?(ЗначениеЗаполнено(СтатьяДДСИсходящий), СтатьяДДСИсходящий, Справочники.СтатьиДвиженияДенежныхСредств.ОплатаПоставщикам)
		ИЛИ СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.Прочее
		ИЛИ СтатьяДДС = ?(ЗначениеЗаполнено(СтатьяДДСВходящий), СтатьяДДСВходящий, Справочники.СтатьиДвиженияДенежныхСредств.ОплатаОтПокупателей)
		ИЛИ НЕ ЗначениеЗаполнено(СтатьяДДС)) Тогда
		
		Если ВидОперацииПрочееСписание = Перечисления.ВидыОперацийРасходСоСчета.Покупателю Тогда
			Возврат ?(ЗначениеЗаполнено(СтатьяДДСВходящий), СтатьяДДСВходящий, Справочники.СтатьиДвиженияДенежныхСредств.ОплатаОтПокупателей);
		ИначеЕсли ВидОперацииПрочееСписание = Перечисления.ВидыОперацийРасходСоСчета.Поставщику Тогда
			Возврат ?(ЗначениеЗаполнено(СтатьяДДСИсходящий), СтатьяДДСИсходящий, Справочники.СтатьиДвиженияДенежныхСредств.ОплатаПоставщикам);
		Иначе
			Возврат Справочники.СтатьиДвиженияДенежныхСредств.Прочее;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат НоваяСтатьяДДС;
	
КонецФункции

Функция ПолучитьНовоеЗначениеСтатьиДДСПоступления(ВидОперацииПрочееПоступление, СтатьяДДС, СтатьяДДСВходящий, СтатьяДДСИсходящий) Экспорт
	
	НоваяСтатьяДДС = СтатьяДДС;
	
	Если (СтатьяДДС = ?(ЗначениеЗаполнено(СтатьяДДСВходящий), СтатьяДДСВходящий, Справочники.СтатьиДвиженияДенежныхСредств.ОплатаОтПокупателей)
		ИЛИ СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.Прочее
		ИЛИ СтатьяДДС = ?(ЗначениеЗаполнено(СтатьяДДСИсходящий), СтатьяДДСИсходящий, Справочники.СтатьиДвиженияДенежныхСредств.ОплатаПоставщикам)
		ИЛИ НЕ ЗначениеЗаполнено(СтатьяДДС)) Тогда
		
		Если ВидОперацииПрочееПоступление = Перечисления.ВидыОперацийПоступлениеНаСчет.ОтПокупателя Тогда
			Возврат ?(ЗначениеЗаполнено(СтатьяДДСВходящий), СтатьяДДСВходящий, Справочники.СтатьиДвиженияДенежныхСредств.ОплатаОтПокупателей);
		ИначеЕсли ВидОперацииПрочееПоступление = Перечисления.ВидыОперацийПоступлениеНаСчет.ОтПоставщика Тогда
			Возврат ?(ЗначениеЗаполнено(СтатьяДДСИсходящий), СтатьяДДСИсходящий, Справочники.СтатьиДвиженияДенежныхСредств.ОплатаПоставщикам);
		Иначе
			Возврат Справочники.СтатьиДвиженияДенежныхСредств.Прочее;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат НоваяСтатьяДДС;
	
КонецФункции

Функция ПолучитьОстатокНаСчете(БанковскийСчет, Организация) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЕСТЬNULL(ДенежныеСредстваОстатки.СуммаВалОстаток, 0) КАК СуммаВалОстаток
		|ИЗ
		|	РегистрНакопления.ДенежныеСредства.Остатки(
		|			,
		|			Организация = &Организация И
		|				БанковскийСчетКасса = &БанковскийСчет) КАК ДенежныеСредстваОстатки";
	
	Запрос.УстановитьПараметр("БанковскийСчет", БанковскийСчет);
	Запрос.УстановитьПараметр("Организация", УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(Организация));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.СуммаВалОстаток;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

Функция ЗаголовокНадписиОстатковДС(СчетКасса, Организация, ОстатокДенежныхСредств = 0) Экспорт
	
	КрупныйШрифт = Новый Шрифт(,11);
	МелкийШрифт  = Новый Шрифт(,8);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СчетКасса", СчетКасса);
	Запрос.УстановитьПараметр("Организация", УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(Организация));
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДенежныеСредстваОстатки.Валюта КАК Валюта,
	|	ДенежныеСредстваОстатки.СуммаВалОстаток КАК Сумма
	|ИЗ
	|	РегистрНакопления.ДенежныеСредства.Остатки(
	|			,
	|			Организация = &Организация
	|				И БанковскийСчетКасса = &СчетКасса) КАК ДенежныеСредстваОстатки";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Сумма = Выборка.Сумма;
		Валюта = Выборка.Валюта;
	Иначе
		Сумма = 0;
		Если ТипЗнч(СчетКасса) = Тип("СправочникСсылка.Кассы") Тогда
			Валюта = СчетКасса.ВалютаПоУмолчанию;
		Иначе
			Валюта = СчетКасса.ВалютаДенежныхСредств;
		КонецЕсли;
	КонецЕсли;
	
	ОстатокДенежныхСредств = Сумма;
	
	КомпонентыФС = Новый Массив;
	КомпонентыФС.Добавить(Новый ФорматированнаяСтрока(НСтр("ru='Остаток'") + " ", КрупныйШрифт));
	
	СуммаСтрокой = Формат(Сумма, "ЧДЦ=2; ЧРД=,; ЧРГ=' '; ЧН=0,00");
	ПозицияРазделителя = СтрНайти(СуммаСтрокой, ",");
	КомпонентыЧисла = Новый Массив;
	КомпонентыЧисла.Добавить(Новый ФорматированнаяСтрока(Лев(СуммаСтрокой, ПозицияРазделителя), КрупныйШрифт));
	КомпонентыЧисла.Добавить(Новый ФорматированнаяСтрока(Сред(СуммаСтрокой, ПозицияРазделителя+1), МелкийШрифт));
	КомпонентыФС.Добавить(Новый ФорматированнаяСтрока(КомпонентыЧисла, , , , "Остаток"));
	
	КомпонентыФС.Добавить(" " + Валюта.СимвольноеПредставление);
	
	Возврат Новый ФорматированнаяСтрока(КомпонентыФС, , ЦветаСтиля.ТекстВторостепеннойНадписи);
	
КонецФункции

#Область ПоступлениеДС

Функция ПолучитьСписокВидовОперацийПоступленияДСБанк() Экспорт
	
	СписокОпераций = Новый СписокЗначений();
	
	СписокОпераций.Добавить(Перечисления.ВидыОперацийПоступлениеНаСчет.ОтПокупателя);
	СписокОпераций.Добавить(Перечисления.ВидыОперацийПоступлениеНаСчет.Прочее, "Прочее поступление"); // Прочее.
	СписокОпераций.Добавить(Перечисления.ВидыОперацийПоступлениеНаСчет.ОтПоставщика, "От поставщика (возврат)");
	
	Если ПолучитьФункциональнуюОпцию("КредитыИЗаймы") Тогда
		СписокОпераций.Добавить(Перечисления.ВидыОперацийПоступлениеНаСчет.РасчетыПоКредитам, "Получение кредита"); // Прочие расчеты.
		СписокОпераций.Добавить(Перечисления.ВидыОперацийПоступлениеНаСчет.ВозвратЗаймаСотрудником); // Прочие расчеты.
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("УчетВалютныхОпераций") Тогда
		СписокОпераций.Добавить(Перечисления.ВидыОперацийПоступлениеНаСчет.ПокупкаВалюты);
	КонецЕсли;
	
	СписокОпераций.Добавить(Перечисления.ВидыОперацийПоступлениеНаСчет.ПрочиеРасчеты, "От прочего контрагента (учредителя)"); // Прочие расчеты.
	СписокОпераций.Добавить(Перечисления.ВидыОперацийПоступлениеНаСчет.ОтПодотчетника);
	
	Если ПолучитьФункциональнуюОпцию("ВестиУчетРасчетовСБанкомЭквайрером") Тогда
		СписокОпераций.Добавить(Перечисления.ВидыОперацийПоступлениеНаСчет.ПоступлениеОплатыПоКартам); // Эквайринг
	КонецЕсли;
	
	СписокОпераций.Добавить(Перечисления.ВидыОперацийПоступлениеНаСчет.Налоги);
	СписокОпераций.Добавить(Перечисления.ВидыОперацийПоступлениеНаСчет.ВзносНаличными);
	СписокОпераций.Добавить(Перечисления.ВидыОперацийПоступлениеНаСчет.ПереводСДругогоСчета);
	
	Возврат СписокОпераций;
	
КонецФункции

Функция ПолучитьСписокВидовОперацийПоступленияДСКасса() Экспорт
	
	СписокОпераций = Новый СписокЗначений();
	
	СписокОпераций.Добавить(Перечисления.ВидыОперацийПоступлениеВКассу.ОтПокупателя);
	СписокОпераций.Добавить(Перечисления.ВидыОперацийПоступлениеВКассу.Прочее);
	СписокОпераций.Добавить(Перечисления.ВидыОперацийПоступлениеВКассу.ОтПоставщика);
	СписокОпераций.Добавить(Перечисления.ВидыОперацийПоступлениеВКассу.ПолучениеНаличныхВБанке);
	
	Если ПолучитьФункциональнуюОпцию("КредитыИЗаймы") Тогда
		СписокОпераций.Добавить(Перечисления.ВидыОперацийПоступлениеВКассу.РасчетыПоКредитам, "Получение кредита"); // Прочие расчеты.
		СписокОпераций.Добавить(Перечисления.ВидыОперацийПоступлениеВКассу.ВозвратЗаймаСотрудником); // Прочие расчеты.
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("УчетВалютныхОпераций") Тогда
		СписокОпераций.Добавить(Перечисления.ВидыОперацийПоступлениеВКассу.ПокупкаВалюты);
	КонецЕсли;
	
	СписокОпераций.Добавить(Перечисления.ВидыОперацийПоступлениеВКассу.ПрочиеРасчеты, "От прочего контрагента (учредителя)"); // Прочие расчеты.
	СписокОпераций.Добавить(Перечисления.ВидыОперацийПоступлениеВКассу.ОтПодотчетника);
	
	Если ПолучитьФункциональнуюОпцию("УчетРозничныхПродаж") Тогда
		СписокОпераций.Добавить(Перечисления.ВидыОперацийПоступлениеВКассу.РозничнаяВыручка);
		СписокОпераций.Добавить(Перечисления.ВидыОперацийПоступлениеВКассу.РозничнаяВыручкаСуммовойУчет);
	КонецЕсли;
	
	Возврат СписокОпераций;
	
КонецФункции

#КонецОбласти

#Область РасходДС

Функция ПолучитьСписокВидовОперацийРасходДСБанк() Экспорт
	
	СписокОпераций = Новый СписокЗначений();
	
	СписокОпераций.Добавить(Перечисления.ВидыОперацийРасходСоСчета.Поставщику, "Поставщику");
	СписокОпераций.Добавить(Перечисления.ВидыОперацийРасходСоСчета.НаРасходы, "На расходы");
	
	// Зарплата по ведомости
	Если Константы.ФункциональнаяОпцияИспользоватьПодсистемуЗарплата.Получить() Тогда
		СписокОпераций.Добавить(Перечисления.ВидыОперацийРасходСоСчета.Зарплата, "Зарплата по ведомости");
	КонецЕсли;
	
	СписокОпераций.Добавить(Перечисления.ВидыОперацийРасходСоСчета.ПрочиеРасчеты, "Прочему контрагенту (учредителю)"); // Прочие расчеты.
	СписокОпераций.Добавить(Перечисления.ВидыОперацийРасходСоСчета.Покупателю, "Покупателю (возврат)");
	
	Если ПолучитьФункциональнуюОпцию("КредитыИЗаймы") Тогда
		СписокОпераций.Добавить(Перечисления.ВидыОперацийРасходСоСчета.РасчетыПоКредитам, "Возврат кредита"); // Прочие расчеты.
		СписокОпераций.Добавить(Перечисления.ВидыОперацийРасходСоСчета.ВыдачаЗаймаСотруднику); // Прочие расчеты.
	КонецЕсли;
	
	СписокОпераций.Добавить(Перечисления.ВидыОперацийРасходСоСчета.Прочее, "Прочий расход"); // Прочее.
	СписокОпераций.Добавить(Перечисления.ВидыОперацийРасходСоСчета.Подотчетнику); // Подотчетнику.
	
	Если ПолучитьФункциональнуюОпцию("ВестиУчетРасчетовСБанкомЭквайрером") Тогда
		СписокОпераций.Добавить(Перечисления.ВидыОперацийРасходСоСчета.ВозвратОплатыНаПлатежныеКарты, "Отчет эквайрера"); // Эквайринг
	КонецЕсли;
	
	СписокОпераций.Добавить(Перечисления.ВидыОперацийРасходСоСчета.Налоги, "Налоги"); // Налоги.
	СписокОпераций.Добавить(Перечисления.ВидыОперацийРасходСоСчета.СнятиеНаличных, "Снятие наличных");
	СписокОпераций.Добавить(Перечисления.ВидыОперацийРасходСоСчета.ПереводНаДругойСчет, "Перевод на другой счет");
	
	Возврат СписокОпераций;
	
КонецФункции

Функция ПолучитьСписокВидовОперацийРасходДСКасса() Экспорт
	
	СписокОпераций = Новый СписокЗначений();
	
	СписокОпераций.Добавить(Перечисления.ВидыОперацийРасходИзКассы.Поставщику, "Поставщику");
	СписокОпераций.Добавить(Перечисления.ВидыОперацийРасходИзКассы.НаРасходы, "На расходы");
	// Зарплата по ведомости
	Если Константы.ФункциональнаяОпцияИспользоватьПодсистемуЗарплата.Получить() Тогда
		СписокОпераций.Добавить(Перечисления.ВидыОперацийРасходИзКассы.Зарплата, "Зарплата по ведомости");
		СписокОпераций.Добавить(Перечисления.ВидыОперацийРасходИзКассы.ЗарплатаСотруднику, "Зарплата сотруднику");
	КонецЕсли;
	СписокОпераций.Добавить(Перечисления.ВидыОперацийРасходИзКассы.ПрочиеРасчеты, "Прочему контрагенту (учредителю)"); // Прочие расчеты.
	СписокОпераций.Добавить(Перечисления.ВидыОперацийРасходИзКассы.Покупателю, "Покупателю (возврат)");
	Если ПолучитьФункциональнуюОпцию("КредитыИЗаймы") Тогда
		СписокОпераций.Добавить(Перечисления.ВидыОперацийРасходИзКассы.РасчетыПоКредитам, "Возврат кредита"); // Прочие расчеты.
		СписокОпераций.Добавить(Перечисления.ВидыОперацийРасходИзКассы.ВыдачаЗаймаСотруднику); // Прочие расчеты.
	КонецЕсли;
	СписокОпераций.Добавить(Перечисления.ВидыОперацийРасходИзКассы.Прочее, "Прочий расход"); // Прочее.
	СписокОпераций.Добавить(Перечисления.ВидыОперацийРасходИзКассы.Подотчетнику); // Подотчетнику.
	Если Константы.ФункциональнаяОпцияУчетРозничныхПродаж.Получить() Тогда
		СписокОпераций.Добавить(Перечисления.ВидыОперацийРасходИзКассы.ПеремещениеВКассуККМ); // Эквайринг
	КонецЕсли;
	СписокОпераций.Добавить(Перечисления.ВидыОперацийРасходИзКассы.Налоги, "Налоги"); // Налоги.
	СписокОпераций.Добавить(Перечисления.ВидыОперацийРасходИзКассы.ВзносНаличнымиВБанк, "Наличные в банк"); // Наличные в банк.
	
	Возврат СписокОпераций;
	
КонецФункции

#КонецОбласти

#Область ХозяйственныеОперацииПоступленияИСписания

Функция ПолучитьСписокХозОперацийПоступленияДС() Экспорт
	
	СписокОпераций = Новый СписокЗначений();
	
	СписокОпераций.Добавить(Справочники.ХозяйственныеОперации.ОтПокупателя);
	СписокОпераций.Добавить(Справочники.ХозяйственныеОперации.Прочее, "Прочее поступление"); // Прочее.
	СписокОпераций.Добавить(Справочники.ХозяйственныеОперации.ОтПоставщика, "От поставщика (возврат)");
	
	Если ПолучитьФункциональнуюОпцию("КредитыИЗаймы") Тогда
		СписокОпераций.Добавить(Справочники.ХозяйственныеОперации.РасчетыПоКредитам, "Расчеты по кредитам"); // Прочие расчеты.
		СписокОпераций.Добавить(Справочники.ХозяйственныеОперации.ВозвратЗаймаСотрудником); // Прочие расчеты.
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("УчетВалютныхОпераций") Тогда
		СписокОпераций.Добавить(Справочники.ХозяйственныеОперации.ПокупкаВалюты);
	КонецЕсли;
	
	СписокОпераций.Добавить(Справочники.ХозяйственныеОперации.ПрочиеРасчеты, "Прочие расчеты"); // Прочие расчеты.
	СписокОпераций.Добавить(Справочники.ХозяйственныеОперации.ОтПодотчетника);
	
	Если ПолучитьФункциональнуюОпцию("ВестиУчетРасчетовСБанкомЭквайрером") Тогда
		СписокОпераций.Добавить(Справочники.ХозяйственныеОперации.ПоступлениеОплатыПоКартам); // Эквайринг
	КонецЕсли;
	
	СписокОпераций.Добавить(Справочники.ХозяйственныеОперации.Налоги);
	
	Если ПолучитьФункциональнуюОпцию("УчетРозничныхПродаж") Тогда
		СписокОпераций.Добавить(Справочники.ХозяйственныеОперации.РозничнаяВыручка);
		СписокОпераций.Добавить(Справочники.ХозяйственныеОперации.РозничнаяВыручкаСуммовойУчет);
	КонецЕсли;
	
	Возврат СписокОпераций;
	
КонецФункции

Функция ПолучитьСписокХОзОперацийРасходДС() Экспорт
	
	СписокОпераций = Новый СписокЗначений();
	
	СписокОпераций.Добавить(Справочники.ХозяйственныеОперации.Поставщику, "Поставщику");
	СписокОпераций.Добавить(Справочники.ХозяйственныеОперации.НаРасходы, "На расходы");
	
	// Зарплата по ведомости
	Если Константы.ФункциональнаяОпцияИспользоватьПодсистемуЗарплата.Получить() Тогда
		СписокОпераций.Добавить(Справочники.ХозяйственныеОперации.Зарплата, "Зарплата по ведомости");
		СписокОпераций.Добавить(Справочники.ХозяйственныеОперации.ЗарплатаСотруднику, "Зарплата сотруднику");
	КонецЕсли;
	
	СписокОпераций.Добавить(Справочники.ХозяйственныеОперации.ПрочиеРасчеты, "Прочеие расчеты"); // Прочие расчеты.
	СписокОпераций.Добавить(Справочники.ХозяйственныеОперации.Покупателю, "Покупателю (возврат)");
	
	Если ПолучитьФункциональнуюОпцию("КредитыИЗаймы") Тогда
		СписокОпераций.Добавить(Справочники.ХозяйственныеОперации.РасчетыПоКредитам, "Расчеты по кредитам"); // Прочие расчеты.
		СписокОпераций.Добавить(Справочники.ХозяйственныеОперации.ВыдачаЗаймаСотруднику); // Прочие расчеты.
	КонецЕсли;
	
	СписокОпераций.Добавить(Справочники.ХозяйственныеОперации.Прочее, "Прочий расход"); // Прочее.
	СписокОпераций.Добавить(Справочники.ХозяйственныеОперации.Подотчетнику); // Подотчетнику.
	
	Если ПолучитьФункциональнуюОпцию("ВестиУчетРасчетовСБанкомЭквайрером") Тогда
		СписокОпераций.Добавить(Справочники.ХозяйственныеОперации.ВозвратОплатыНаПлатежныеКарты, "Отчет эквайрера"); // Эквайринг
	КонецЕсли;
	
	СписокОпераций.Добавить(Справочники.ХозяйственныеОперации.Налоги, "Налоги"); // Налоги.
	
	Если Константы.ФункциональнаяОпцияУчетРозничныхПродаж.Получить() Тогда
		СписокОпераций.Добавить(Справочники.ХозяйственныеОперации.ПеремещениеВКассуККМ);
	КонецЕсли;
	
	Возврат СписокОпераций;
	
КонецФункции

#КонецОбласти
