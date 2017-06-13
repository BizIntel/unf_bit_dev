﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаСуммовойУчетВРознице(ДокументСсылкаПереоценкаВРозницеСуммовойУчет, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаПереоценкаВРозницеСуммовойУчет);
	Запрос.УстановитьПараметр("МоментВремени", Новый Граница(СтруктураДополнительныеСвойства.ДляПроведения.МоментВремени, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("ПериодКонтроля", СтруктураДополнительныеСвойства.ДляПроведения.МоментВремени.Дата);
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	Запрос.УстановитьПараметр("ПереоценкаВРозницеСуммовойУчет", НСтр("ru = 'Переоценка в рознице'"));
	Запрос.УстановитьПараметр("КурсоваяРазница", НСтр("ru='Курсовая разница'"));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.Дата КАК Дата,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ТаблицаДокумента.Организация КАК Организация,
	|	ТаблицаДокумента.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ТаблицаДокумента.ВалютаДокумента КАК Валюта,
	|	ТаблицаДокумента.СтруктурнаяЕдиницаСчетУчетаВРознице КАК СчетУчета,
	|	ТаблицаДокумента.СтруктурнаяЕдиницаСчетУчетаВРознице КАК СтруктурнаяЕдиницаСчетУчетаВРознице,
	|	ТаблицаДокумента.СтруктурнаяЕдиницаСчетУчетаНаценки КАК СтруктурнаяЕдиницаСчетУчетаНаценки,
	|	ТаблицаДокумента.ЗаказПокупателя КАК ЗаказПокупателя,
	|	СУММА(ТаблицаДокумента.Сумма) КАК Сумма,
	|	СУММА(ТаблицаДокумента.СуммаВал) КАК СуммаВал,
	|	СУММА(ТаблицаДокумента.Сумма) КАК СуммаДляОстатка,
	|	СУММА(ТаблицаДокумента.СуммаВал) КАК СуммаВалДляОстатка,
	|	0 КАК Себестоимость,
	|	&ПереоценкаВРозницеСуммовойУчет КАК СодержаниеПроводки
	|ПОМЕСТИТЬ ВременнаяТаблицаСуммовойУчетВРознице
	|ИЗ
	|	ВременнаяТаблицаЗапасы КАК ТаблицаДокумента
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаДокумента.Дата,
	|	ТаблицаДокумента.НомерСтроки,
	|	ТаблицаДокумента.Организация,
	|	ТаблицаДокумента.СтруктурнаяЕдиница,
	|	ТаблицаДокумента.ВалютаДокумента,
	|	ТаблицаДокумента.СтруктурнаяЕдиницаСчетУчетаВРознице,
	|	ТаблицаДокумента.СтруктурнаяЕдиницаСчетУчетаВРознице,
	|	ТаблицаДокумента.СтруктурнаяЕдиницаСчетУчетаНаценки,
	|	ТаблицаДокумента.ЗаказПокупателя
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	СтруктурнаяЕдиница,
	|	Валюта,
	|	СчетУчета";
	
	Запрос.Выполнить();
	
	// Установка исключительной блокировки контролируемых остатков денежных средств.
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВременнаяТаблицаСуммовойУчетВРознице.Организация КАК Организация,
	|	ВременнаяТаблицаСуммовойУчетВРознице.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ВременнаяТаблицаСуммовойУчетВРознице.Валюта КАК Валюта
	|ИЗ
	|	ВременнаяТаблицаСуммовойУчетВРознице КАК ВременнаяТаблицаСуммовойУчетВРознице";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.СуммовойУчетВРознице");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = РезультатЗапроса;
	
	Для каждого КолонкаРезультатЗапроса Из РезультатЗапроса.Колонки Цикл
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных(КолонкаРезультатЗапроса.Имя, КолонкаРезультатЗапроса.Имя);
	КонецЦикла;
	Блокировка.Заблокировать();
	
	НомерЗапроса = 0;
	Запрос.Текст = УправлениеНебольшойФирмойСервер.ПолучитьТекстЗапросаКурсовыеРазницыСуммовойУчетВРознице(Запрос.МенеджерВременныхТаблиц, НомерЗапроса);
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСуммовойУчетВРознице", МассивРезультатов[НомерЗапроса].Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаДоходыИРасходы()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаДоходыИРасходы(ДокументСсылкаПереоценкаВРозницеСуммовойУчет, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ОтражениеДоходов", НСтр("ru = 'Отражение доходов'"));
	Запрос.УстановитьПараметр("ОтражениеРасходов", НСтр("ru = 'Отражение расходов'"));
	Запрос.УстановитьПараметр("КурсоваяРазница", НСтр("ru='Курсовая разница'"));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ТаблицаДокумента.Дата КАК Период,
	|	ТаблицаДокумента.Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка) КАК СтруктурнаяЕдиница,
	|	ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка) КАК ЗаказПокупателя,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.Прочее) КАК НаправлениеДеятельности,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СуммаКурсовойРазницы > 0
	|			ТОГДА ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПрочиеДоходы)
	|		ИНАЧЕ ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПрочиеРасходы)
	|	КОНЕЦ КАК СчетУчета,
	|	ТаблицаДокумента.Валюта КАК Аналитика,
	|	&КурсоваяРазница КАК СодержаниеПроводки,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СуммаКурсовойРазницы > 0
	|			ТОГДА ТаблицаДокумента.СуммаКурсовойРазницы
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаДоходов,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СуммаКурсовойРазницы > 0
	|			ТОГДА 0
	|		ИНАЧЕ -ТаблицаДокумента.СуммаКурсовойРазницы
	|	КОНЕЦ КАК СуммаРасходов
	|ИЗ
	|	ВременнаяТаблицаКурсовыхРазницСуммовойУчетВРознице КАК ТаблицаДокумента
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки,
	|	ТаблицаДокумента.Дата,
	|	ТаблицаДокумента.Организация,
	|	ТаблицаДокумента.СтруктурнаяЕдиница,
	|	ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка),
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.Прочее),
	|	ТаблицаДокумента.СтруктурнаяЕдиницаСчетУчетаНаценки,
	|	НЕОПРЕДЕЛЕНО,
	|	&ОтражениеРасходов,
	|	0,
	|	-ТаблицаДокумента.Сумма
	|ИЗ
	|	ВременнаяТаблицаЗапасы КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.СтруктурнаяЕдиницаСчетУчетаНаценки.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.ПрочиеРасходы)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки,
	|	ТаблицаДокумента.Дата,
	|	ТаблицаДокумента.Организация,
	|	ТаблицаДокумента.СтруктурнаяЕдиница,
	|	ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка),
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.Прочее),
	|	ТаблицаДокумента.СтруктурнаяЕдиницаСчетУчетаНаценки,
	|	НЕОПРЕДЕЛЕНО,
	|	&ОтражениеДоходов,
	|	ТаблицаДокумента.Сумма,
	|	0
	|ИЗ
	|	ВременнаяТаблицаЗапасы КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.СтруктурнаяЕдиницаСчетУчетаНаценки.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.ПрочиеДоходы)";
		
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДоходыИРасходы", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаДоходыИРасходы()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаУправленческий(ДокументСсылкаПереоценкаВРозницеСуммовойУчет, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ТорговаяНаценка", НСтр("ru = 'Торговая наценка'"));
	Запрос.УстановитьПараметр("КурсоваяРазница", НСтр("ru='Курсовая разница'"));
	Запрос.УстановитьПараметр("ОтражениеДоходов", НСтр("ru = 'Отражение доходов'"));
	Запрос.УстановитьПараметр("ОтражениеРасходов", НСтр("ru = 'Отражение расходов'"));
		
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ТаблицаДокумента.Дата КАК Период,
	|	ТаблицаДокумента.Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Справочник.СценарииПланирования.Фактический) КАК СценарийПланирования,
	|	ТаблицаДокумента.СтруктурнаяЕдиницаСчетУчетаВРознице КАК СчетДт,
	|	ТаблицаДокумента.СтруктурнаяЕдиницаСчетУчетаНаценки КАК СчетКт,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СтруктурнаяЕдиницаСчетУчетаВРознице.Валютный
	|			ТОГДА ТаблицаДокумента.Валюта
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ВалютаДт,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СтруктурнаяЕдиницаСчетУчетаНаценки.Валютный
	|			ТОГДА ТаблицаДокумента.Валюта
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ВалютаКт,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СтруктурнаяЕдиницаСчетУчетаВРознице.Валютный
	|			ТОГДА ТаблицаДокумента.СуммаВал
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК СуммаВалДт,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СтруктурнаяЕдиницаСчетУчетаНаценки.Валютный
	|			ТОГДА ТаблицаДокумента.СуммаВал
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК СуммаВалКт,
	|	ТаблицаДокумента.Сумма КАК Сумма,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СтруктурнаяЕдиницаСчетУчетаНаценки.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.ТорговаяНаценка)
	|			ТОГДА &ТорговаяНаценка
	|		ИНАЧЕ &ОтражениеДоходов
	|	КОНЕЦ КАК Содержание
	|ИЗ
	|	ВременнаяТаблицаСуммовойУчетВРознице КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.СтруктурнаяЕдиницаСчетУчетаНаценки.ТипСчета <> ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.ПрочиеРасходы)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки,
	|	ТаблицаДокумента.Дата,
	|	ТаблицаДокумента.Организация,
	|	ЗНАЧЕНИЕ(Справочник.СценарииПланирования.Фактический),
	|	ТаблицаДокумента.СтруктурнаяЕдиницаСчетУчетаНаценки,
	|	ТаблицаДокумента.СтруктурнаяЕдиницаСчетУчетаВРознице,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СтруктурнаяЕдиницаСчетУчетаНаценки.Валютный
	|			ТОГДА ТаблицаДокумента.Валюта
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СтруктурнаяЕдиницаСчетУчетаВРознице.Валютный
	|			ТОГДА ТаблицаДокумента.Валюта
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СтруктурнаяЕдиницаСчетУчетаНаценки.Валютный
	|			ТОГДА ТаблицаДокумента.СуммаВал
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СтруктурнаяЕдиницаСчетУчетаВРознице.Валютный
	|			ТОГДА ТаблицаДокумента.СуммаВал
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ,
	|	-ТаблицаДокумента.Сумма,
	|	&ОтражениеРасходов
	|ИЗ
	|	ВременнаяТаблицаСуммовойУчетВРознице КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.СтруктурнаяЕдиницаСчетУчетаНаценки.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.ПрочиеРасходы)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки,
	|	ТаблицаДокумента.Дата,
	|	ТаблицаДокумента.Организация,
	|	ЗНАЧЕНИЕ(Справочник.СценарииПланирования.Фактический),
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СуммаКурсовойРазницы > 0
	|			ТОГДА ТаблицаДокумента.СчетУчета
	|		ИНАЧЕ ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПрочиеРасходы)
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СуммаКурсовойРазницы > 0
	|			ТОГДА ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПрочиеДоходы)
	|		ИНАЧЕ ТаблицаДокумента.СчетУчета
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СуммаКурсовойРазницы > 0
	|				И ТаблицаДокумента.СчетУчета.Валютный
	|			ТОГДА ТаблицаДокумента.Валюта
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СуммаКурсовойРазницы < 0
	|				И ТаблицаДокумента.СчетУчета.Валютный
	|			ТОГДА ТаблицаДокумента.Валюта
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ,
	|	0,
	|	0,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СуммаКурсовойРазницы > 0
	|			ТОГДА ТаблицаДокумента.СуммаКурсовойРазницы
	|		ИНАЧЕ -ТаблицаДокумента.СуммаКурсовойРазницы
	|	КОНЕЦ,
	|	&КурсоваяРазница
	|ИЗ
	|	ВременнаяТаблицаКурсовыхРазницСуммовойУчетВРознице КАК ТаблицаДокумента
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаУправленческий", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаУправленческий()

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылкаПереоценкаВРозницеСуммовойУчет, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаПереоценкаВРозницеСуммовойУчет);
	Запрос.УстановитьПараметр("МоментВремени", Новый Граница(СтруктураДополнительныеСвойства.ДляПроведения.МоментВремени, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("ПериодКонтроля", СтруктураДополнительныеСвойства.ДляПроведения.МоментВремени.Дата);
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	Запрос.УстановитьПараметр("ВалютаУчета", Константы.ВалютаУчета.Получить());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МАКСИМУМ(ТаблицаДокумента.НомерСтроки) КАК НомерСтроки,
	|	ТаблицаДокумента.Ссылка.Дата КАК Дата,
	|	ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка) КАК ЗаказПокупателя,
	|	ТаблицаДокумента.Ссылка.ВалютаДокумента КАК ВалютаДокумента,
	|	ТаблицаДокумента.Ссылка.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ТаблицаДокумента.Ссылка.СтруктурнаяЕдиница.СчетУчетаВРознице КАК СтруктурнаяЕдиницаСчетУчетаВРознице,
	|	ТаблицаДокумента.Ссылка.Корреспонденция КАК СтруктурнаяЕдиницаСчетУчетаНаценки,
	|	&Организация КАК Организация,
	|	СУММА(ВЫРАЗИТЬ(ТаблицаДокумента.Сумма * КурсыВалютДокумента.Курс * КурсыВалютУчета.Кратность / (КурсыВалютУчета.Курс * КурсыВалютДокумента.Кратность) КАК ЧИСЛО(15, 2))) КАК Сумма,
	|	СУММА(ТаблицаДокумента.Сумма) КАК СуммаВал
	|ПОМЕСТИТЬ ВременнаяТаблицаЗапасы
	|ИЗ
	|	Документ.ПереоценкаВРозницеСуммовойУчет.Запасы КАК ТаблицаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&МоментВремени, Валюта = &ВалютаУчета) КАК КурсыВалютУчета
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&МоментВремени, ) КАК КурсыВалютДокумента
	|		ПО ТаблицаДокумента.Ссылка.ВалютаДокумента = КурсыВалютДокумента.Валюта
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаДокумента.Ссылка,
	|	ТаблицаДокумента.Ссылка.ВалютаДокумента,
	|	ТаблицаДокумента.Ссылка.СтруктурнаяЕдиница,
	|	ТаблицаДокумента.Ссылка.СтруктурнаяЕдиница.СчетУчетаВРознице,
	|	ТаблицаДокумента.Ссылка.Дата,
	|	ТаблицаДокумента.Ссылка.Корреспонденция";
	
	Запрос.ВыполнитьПакет();
	
	// Формирование таблиц движений по разделам учета.
	СформироватьТаблицаСуммовойУчетВРознице(ДокументСсылкаПереоценкаВРозницеСуммовойУчет, СтруктураДополнительныеСвойства);
	СформироватьТаблицаДоходыИРасходы(ДокументСсылкаПереоценкаВРозницеСуммовойУчет, СтруктураДополнительныеСвойства);
	СформироватьТаблицаУправленческий(ДокументСсылкаПереоценкаВРозницеСуммовойУчет, СтруктураДополнительныеСвойства);
		
КонецПроцедуры // ИнициализироватьДанныеДокумента()

// Выполняет контроль возникновения отрицательных остатков.
//
Процедура ВыполнитьКонтроль(ДокументСсылкаПереоценкаВРозницеСуммовойУчет, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	
	Если НЕ Константы.КонтролироватьОстаткиПриПроведении.Получить() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Если временные таблицы содержат записи, необходимо выполнить контроль
	// отрицательных остатков.
	Если СтруктураВременныеТаблицы.ДвиженияСуммовойУчетВРозницеИзменение Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДвиженияСуммовойУчетВРозницеИзменение.НомерСтроки КАК НомерСтроки,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияСуммовойУчетВРозницеИзменение.Организация) КАК ОрганизацияПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияСуммовойУчетВРозницеИзменение.СтруктурнаяЕдиница) КАК СтруктурнаяЕдиницаПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияСуммовойУчетВРозницеИзменение.СтруктурнаяЕдиница.РозничныйВидЦен.ВалютаЦены) КАК ВалютаПредставление,
		|	ЕСТЬNULL(СуммовойУчетВРозницеОстатки.СуммаОстаток, 0) КАК СуммаОстаток,
		|	ДвиженияСуммовойУчетВРозницеИзменение.СуммаВалИзменение + ЕСТЬNULL(СуммовойУчетВРозницеОстатки.СуммаВалОстаток, 0) КАК ОстатокВРознице,
		|	ДвиженияСуммовойУчетВРозницеИзменение.СуммаПередЗаписью КАК СуммаПередЗаписью,
		|	ДвиженияСуммовойУчетВРозницеИзменение.СуммаПриЗаписи КАК СуммаПриЗаписи,
		|	ДвиженияСуммовойУчетВРозницеИзменение.СуммаИзменение КАК СуммаИзменение,
		|	ДвиженияСуммовойУчетВРозницеИзменение.СуммаВалПередЗаписью КАК СуммаВалПередЗаписью,
		|	ДвиженияСуммовойУчетВРозницеИзменение.СуммаВалПриЗаписи КАК СуммаВалПриЗаписи,
		|	ДвиженияСуммовойУчетВРозницеИзменение.СуммаВалИзменение КАК СуммаВалИзменение,
		|	ДвиженияСуммовойУчетВРозницеИзменение.СебестоимостьПередЗаписью КАК СебестоимостьПередЗаписью,
		|	ДвиженияСуммовойУчетВРозницеИзменение.СебестоимостьПриЗаписи КАК СебестоимостьПриЗаписи,
		|	ДвиженияСуммовойУчетВРозницеИзменение.СебестоимостьИзменение КАК СебестоимостьИзменение
		|ИЗ
		|	ДвиженияСуммовойУчетВРозницеИзменение КАК ДвиженияСуммовойУчетВРозницеИзменение
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.СуммовойУчетВРознице.Остатки(
		|				&МоментКонтроля,
		|				(Организация, СтруктурнаяЕдиница) В
		|					(ВЫБРАТЬ
		|						ДвиженияСуммовойУчетВРозницеИзменение.Организация КАК Организация,
		|						ДвиженияСуммовойУчетВРозницеИзменение.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница
		|					ИЗ
		|						ДвиженияСуммовойУчетВРозницеИзменение КАК ДвиженияСуммовойУчетВРозницеИзменение)) КАК СуммовойУчетВРозницеОстатки
		|		ПО ДвиженияСуммовойУчетВРозницеИзменение.Организация = СуммовойУчетВРозницеОстатки.Организация
		|			И ДвиженияСуммовойУчетВРозницеИзменение.СтруктурнаяЕдиница = СуммовойУчетВРозницеОстатки.СтруктурнаяЕдиница
		|ГДЕ
		|	ЕСТЬNULL(СуммовойУчетВРозницеОстатки.СуммаВалОстаток, 0) < 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки");
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.УстановитьПараметр("МоментКонтроля", ДополнительныеСвойства.ДляПроведения.МоментКонтроля);
		
		МассивРезультатов = Запрос.ВыполнитьПакет();
		
		Если НЕ МассивРезультатов[0].Пустой() Тогда
			ДокументОбъектПереоценкаВРозницеСуммовойУчет = ДокументСсылкаПереоценкаВРозницеСуммовойУчет.ПолучитьОбъект()
		КонецЕсли;
		
		// Отрицательный остаток по суммовому учету в рознице.
		Если НЕ МассивРезультатов[0].Пустой() Тогда
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[0].Выбрать();
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибкахПроведенияПоРегиструСуммовойУчетВРознице(ДокументОбъектПереоценкаВРозницеСуммовойУчет, ВыборкаИзРезультатаЗапроса, Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ВыполнитьКонтроль()

#Область ИнтерфейсПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли