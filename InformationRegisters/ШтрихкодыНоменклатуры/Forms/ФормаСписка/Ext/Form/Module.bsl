﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Номенклатура") Тогда
		УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(Список, "Номенклатура", Параметры.Номенклатура);
		Если НЕ (Параметры.Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Запас 
			ИЛИ Параметры.Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Услуга
			ИЛИ Параметры.Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Работа)
			Тогда
			АвтоЗаголовок = Ложь;
			Заголовок = НСтр("ru = 'Штрихкоды хранятся только для запасов, работ и услуг'");
			Элементы.Список.ТолькоПросмотр = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры