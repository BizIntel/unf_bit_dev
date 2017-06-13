﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ПустаяСтрока(Параметры.ЗаголовокФормы) Тогда
		Заголовок = Параметры.ЗаголовокФормы;
	КонецЕсли;
	
	Элементы.Отборы.Заголовок = Параметры.ПредставлениеОтборов;
	Элементы.Отборы.Видимость = НЕ ПустаяСтрока(Параметры.ПредставлениеОтборов);
	
	Если ЭтоАдресВременногоХранилища(Параметры.АдресТабличногоДокумента) Тогда
		ТабДок = ПолучитьИзВременногоХранилища(Параметры.АдресТабличногоДокумента);
	КонецЕсли;
	
КонецПроцедуры
