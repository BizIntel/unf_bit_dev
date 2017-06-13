﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	АдресСчетаУчетаВХранилище = Параметры.АдресСчетаУчетаВХранилище;
	СчетаУчета.Загрузить(ПолучитьИзВременногоХранилища(АдресСчетаУчетаВХранилище));
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ЗаписатьСчетаУчетаВХранилище();
	Закрыть(КодВозвратаДиалога.OK);

КонецПроцедуры // ОК()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
// Процедура помещает результаты подбора в хранилище.
//
Процедура ЗаписатьСчетаУчетаВХранилище() 
	
	ПоместитьВоВременноеХранилище(СчетаУчета.Выгрузить(), АдресСчетаУчетаВХранилище);
	
КонецПроцедуры

#КонецОбласти
