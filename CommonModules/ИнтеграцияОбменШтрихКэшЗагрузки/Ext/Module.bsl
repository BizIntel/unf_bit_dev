﻿
Функция ДатьКэшОбработкиДокументов(ОбластьЗагрузки) Экспорт
	
	Кэш = Новый Структура(
		"Номенклатура, Кассы, Кассиры, КассовыеСмены, ЕдиницыИзмеренияНоменклатуры,СтавкиНДСНоменклатуры,СтавкиНДССтавокНДС,ТорговыеТочкиКасс, ВидыЦенКасс", 
		Новый Соответствие(),
		Новый Соответствие(),
		Новый Соответствие(),
		Новый Соответствие(),
		Новый Соответствие(),
		Новый Соответствие(),
		Новый Соответствие(),
		Новый Соответствие(),
		Новый Соответствие());
	
	Возврат Кэш;
	
КонецФункции