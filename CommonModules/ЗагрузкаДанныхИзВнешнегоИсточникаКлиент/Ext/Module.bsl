﻿
#Область СлужебныеПроцедурыИФункции
// В частной разработке использование служебных процедур и функций не рекомендуется

Процедура ПоказатьФормуЗагрузкиДанныхИзВнешнегоИсточника(НастройкиЗагрузкиДанных, ОписаниеОповещения, Владелец) Экспорт
	
	Если СтрНайти(НастройкиЗагрузкиДанных.ИмяФормыЗагрузкиДанныхИзВнешнихИсточников, "ЗагрузкаДанныхИзФайла") > 0 Тогда
		
		ПараметрыЗагрузкиДанных = НастройкиЗагрузкиДанных;
		
	ИначеЕсли СтрНайти(НастройкиЗагрузкиДанных.ИмяФормыЗагрузкиДанныхИзВнешнихИсточников, "ЗагрузкаДанныхИзВнешнегоИсточника") > 0 Тогда
		
		ПараметрыЗагрузкиДанных = Новый Структура("НастройкиЗагрузкиДанных", НастройкиЗагрузкиДанных);
		
	КонецЕсли;
	
	ОткрытьФорму(НастройкиЗагрузкиДанных.ИмяФормыЗагрузкиДанныхИзВнешнихИсточников, ПараметрыЗагрузкиДанных, Владелец, , , , ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти