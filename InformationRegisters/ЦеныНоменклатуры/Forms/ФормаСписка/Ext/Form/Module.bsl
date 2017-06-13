﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установка доступности цен для редактирования.
	РазрешеноРедактированиеЦенДокументов = УправлениеНебольшойФирмойУправлениеДоступомПовтИсп.ЕстьПравоДоступа(
		"Изменение",
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.РегистрыСведений.ЦеныНоменклатуры)
	);
	
	Элементы.Список.ТолькоПросмотр = НЕ РазрешеноРедактированиеЦенДокументов;
	
КонецПроцедуры
