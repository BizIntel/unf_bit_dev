﻿// Функция возвращает основную организацию для текущего пользователя
//
//
// Параметры:
//  Отсутствуют
//
// Результат:
//  СправочникСсылка.Организации - основная организация для текущего пользователя
//
Функция ОсновнаяОрганизация() Экспорт
	
	Организация = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователи.ТекущийПользователь(), "ОсновнаяОрганизация");
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Организация =УправлениеНебольшойФирмойСервер.ПолучитьПредопределеннуюОрганизацию();
	КонецЕсли;
	
	Возврат Организация;
	
КонецФункции

// Предназначена для переопределения состояния сдачи отчетности в контролирующие органы
//
// Параметры:
//  Ссылка  - Справочникссылка, ДокументСсылка - объект, отправляемый в контролирующие органы по ТКС
//  СтатусОтправки  - Строка - Состояние, предназанченно для отображения пользователю, например "Отправлено в ФНС" или "Сдано"
//  СостояниеСдачиОтчетности - Перечисление.СостояниеСдачиОтчетности - отображает текущий результат сдачи отчетности  
//
Процедура ПереопределитьСтатусИСостояниеСдачиОтчетности(Ссылка, СтатусОтправки, СостояниеСдачиОтчетности) Экспорт
	
КонецПроцедуры

// Процедура - Предназначена для заполнения кода органа ФСГС в организации.
// 		Если в организации не задан код органа ФСГС, а во вторичном мастере подключения к 1С-Отчетности
//		пользователь его задал, то указанный код ФСГС должен записываться в организацию 
//		при помощи данной функции.
//		Если код органа ФСГС в организации хранится в реквизите КодОрганаФСГС, то данную
//		процедуру можно не заполнять.
//
// Параметры:
//  Организация			 - Справочники.Организация 	- организация, в которой необходимо изменить код органа ФСГС.
//  НовыйКодОрганаФСГС	 - Строка 					- новый код ФСГС
//  СтандартнаяОбработка - Булево 					- если Ложь, то выполняется действе указанное в данной процедуре,
//														иначе стандартное действие.
Процедура ЗадатьКодОрганаФСГСВОрганизации(Организация, НовыйКодОрганаФСГС, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Заполняется при наличии в конфигурации библиотеки БЭД:
// Заполняет значения элементов структуры, передаваемой в параметрах.
//
// Параметры:
//   Организация - СправочникСсылка.Организации
//	 СтруктураПараметров - структура. Возможные поля:
//     ЕстьПодключениеЭДО 		- Булево
//     МассивОператоровЭДО 		- Массив строк
//     СсылкаОписаниеСервиса 	- Строка, ссылка на описание сервиса и условия подключения
// Пример:
//	ЭлектронныеДокументы.ЗаполнитьДанныеПо1СЭДОДляМастера1СОтчетности(Организация, СтруктураПараметров);
//
Процедура ЗаполнитьПараметрыСервисаЭлектронныхДокументовДляФормыПодключенияК1СООтчетности(Организация, СтруктураПараметров) Экспорт
	ОбменСКонтрагентами.ЗаполнитьДанныеПо1СЭДОДляМастера1СОтчетности(Организация, СтруктураПараметров);
КонецПроцедуры

// Процедура - Изображение (картинка) логотипа организации
//
// Параметры:
//  Организация	 - СправочникСсылка.Организации - Организация, для которой
//		необходимо вернуть логотип.
//  Логотип		 - ДвоичныеДанные - ДвоичныеДанные изображения логотипа организации.
//
// Пример:
// 	ДанныеКартинки = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаИДвоичныеДанные(Организация.ФайлЛоготип);
//	Возврат ДанныеКартинки.ДвоичныеДанные;
Процедура ЛоготипОрганизации(Организация, Логотип) Экспорт
	
КонецПроцедуры

// Процедура - Изображение (картинка) подписи руководителя организации
//
// Параметры:
//  Организация	 - СправочникСсылка.Организации - Организация, для которой
//		необходимо вернуть логотип.
//  Подпись		 - ДвоичныеДанные - ДвоичныеДанные изображения подписи организации.
//
// Пример:
// 	ДанныеКартинки = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаИДвоичныеДанные(Организация.ФайлПодписьРуководителя);
//	Возврат ДанныеКартинки.ДвоичныеДанные;
Процедура ПодписьРуководителя(Организация, Подпись) Экспорт
	
КонецПроцедуры

// Переопределение списка кодов видов операций выданных и полученных счетов-фактур.
//
// Параметры:
//  КодыВидовОпераций	 - СписокЗначений - Коды видов операций выданных и полученных счетов-фактур.
//  Дата				 - Дата - Дата, на которую должен быть получен актуальный список кодов.
//  ЭтоПолученныеСФ		 - Булево - Определяет вид счета-фактуры.
// 
Процедура ЗаполнитьСписокКодовВидовОперацийСчетовФактур(СписокКодов, Дата, ЭтоПолученныеСФ) Экспорт
	
КонецПроцедуры

// Позволяет определить, какие реквизиты заявления по 1С-Отчетности могут быть заполнены в базе и получены из нее, 
// а какие не могут (например, если скрыты функциональной опцией, недоступны из-за прав, этих данных нет в базе).
//
// Параметры:
//  Реквизиты - Соответствие - Содержит перечень видов реквизитов и признак - есть ли реквизит в базе или нет:
//      * Ключ - Перечисление.ПараметрыПодключенияК1СОтчетности - одно из следующих значений:
//           * ТелефонОсновной - основной телефон организации
//           * ТелефонДополнительный - дополнительный телефон организации
//           * ЭлектроннаяПочта - электронная почта организации
//           * ВладелецЭЦПДолжность - должность физического лица или сотрудника не хранится
//           * ВладелецЭЦППодразделение - подразделение физического лица или сотрудника
//           * ВладелецЭЦПСНИЛС - СНИЛС физического лица или сотрудника
//           * ДополнительныйКодФСС - дополнительный код ФСС организации.
//           * ВладелецЭЦПМестоРождения - место рождения физического лица или сотрудника.
//           * ВладелецЭЦПДатаРождения - дата рождения физического лица или сотрудника.
//           * ВладелецЭЦПКодПодразделения - код подразделения органиазии, выдавшего документ, удостоверящий личность.
//           * ВладелецЭЦППол - пол физического лица или сотрудника.
//           * ВладелецЭЦПГражданство - гражданство физического лица или сотрудника.
//      * Значение - Булево - определяет, хранится ли реквизит в базе или нет. Следует учитывать, что 
//           данное значение может быть установлено различными потребителями и библиотеками. 
//           Поэтому, если флаг уже взведен в Истина, то сбрасывать его не нужно.
//
Процедура ОпределитьНаличиеДанныхДляЗаявленияНаСертификат(Реквизиты, Организация = Неопределено) Экспорт
	
	Реквизиты.Вставить(Перечисления.ПараметрыПодключенияК1СОтчетности.ТелефонОсновной,             Истина);
	Реквизиты.Вставить(Перечисления.ПараметрыПодключенияК1СОтчетности.ТелефонДополнительный,       Ложь);
	Реквизиты.Вставить(Перечисления.ПараметрыПодключенияК1СОтчетности.ВладелецЭЦПДолжность,        Истина);
	Реквизиты.Вставить(Перечисления.ПараметрыПодключенияК1СОтчетности.ВладелецЭЦППодразделение,    Ложь);
	Реквизиты.Вставить(Перечисления.ПараметрыПодключенияК1СОтчетности.ВладелецЭЦПСНИЛС,            Истина);
	Реквизиты.Вставить(Перечисления.ПараметрыПодключенияК1СОтчетности.ВладелецЭЦПМестоРождения,    Ложь);
	Реквизиты.Вставить(Перечисления.ПараметрыПодключенияК1СОтчетности.ВладелецЭЦПДатаРождения,     Истина);
	Реквизиты.Вставить(Перечисления.ПараметрыПодключенияК1СОтчетности.ВладелецЭЦПКодПодразделения, Ложь);
	Реквизиты.Вставить(Перечисления.ПараметрыПодключенияК1СОтчетности.ВладелецЭЦППол,              Истина);
	Реквизиты.Вставить(Перечисления.ПараметрыПодключенияК1СОтчетности.ВладелецЭЦПГражданство,      Истина);
	Реквизиты.Вставить(Перечисления.ПараметрыПодключенияК1СОтчетности.ДополнительныйКодФСС,        Ложь);
	Реквизиты.Вставить(Перечисления.ПараметрыПодключенияК1СОтчетности.ЭлектроннаяПочта,            Истина);
	
КонецПроцедуры


#Область ДокументыПоТребованиюФНС

//Заполняет реквизиты контрагента по ссылке:
// 	Представление
//	НаименованиеПолное
//	ЮридическоеФизическоеЛицо
//	ИНН
//	КПП
//
//Процедуру следует заполнить, если справочник Контрагенты не обладает хотя бы одним из реквизитов:
//	НаименованиеПолное
//	ЮридическоеФизическоеЛицо
//	ИНН
//	КПП
//
//Параметры:
//
//	Контрагент - СправочникСсылка.Контрагенты
//	РеквизитыКонтрагента - Структура. Поля структуры, обязательные к заполнению:
// 		Представление				- Строка
//		НаименованиеПолное          - Строка
//		ЮридическоеФизическоеЛицо   - Булево
//		ИНН                         - Строка
//		КПП                         - Строка
//
Процедура ПолучитьРеквизитыКонтрагента(Контрагент, РеквизитыКонтрагента) Экспорт

КонецПроцедуры

//Заполняет массив контрагентов с указанным ИНН
//
//Процедуру следует заполнить, если справочник Контрагенты не обладает хотя бы одним из реквизитов:
//	НаименованиеПолное
//	ЮридическоеФизическоеЛицо
//	ИНН
//	КПП
//
//Параметры:
//
//	ИНН - Строка
//	МассивКонтрагентов - Массив ссылок на справочник контрагентов
//
Процедура ПолучитьМассивКонтрагентовПоИНН(ИНН, МассивКонтрагентов) Экспорт

КонецПроцедуры

//Формирует сведения о документах-источниках, которые будут использоваться для заполнения реквизитов сканированных документов, 
//представляемых по требованию ФНС. Требуется заполнить для всех объектов метаданных,
//указанных в определяемом типе ИсточникДокументаПоТребованиюФНСБРО, за исключением тех, 
//которые предназначены исключительно для формирования элетронных документов.
//
//Параметры:
//
//	СвойстваИсточников	- Соответствие, соответствие переданных ссылок на источники и массива структур
//		Ключ 		– ссылка на источник для заполнения реквизитов сканированных документов
//		Значение 	– Массив, массив структур (начальное значение: пустой массив)
//		(каждый элемент массива – реквизиты для заполнения одного сканированного документа)
//
//		В общем случае один источник может служить источником для заполнения реквизитов нескольких сканированных документов (например документы РеализацияТоваровУслуг, ОказаниеУслуг).
//		Если у источника стоит пометка на удаление, массив структур должен остаться пустым.
//		Состав полей структуры различен для различных видов документов.
//
//		Поля структуры:
//
//			(обязательный)		Организация				- СправочникСсылка.Организации
//			(обязательный)		ВидДокументаФНС 		- ПеречислениеСсылка.ВидыПредставляемыхДокументов
//			(необязательный)	НомерСтрокиИсточника	- Число, обязательно указывается, если данный источник может служить 
//														источником для заполнения реквизитов нескольких документов одного вида ФНС  
//														Для остальных документов-источников не указывается.
//			(необязательный)	Направление 			- Перечисление.НаправленияДокументаПоТребованиюФНС,
//														обязателен для следующих видов документов ФНС:
//															Счет-фактура
//															Корректировочный счет-фактура
//															Акт приемки-сдачи работ (услуг)
//															Товарная накладная (ТОРГ-12)
//															Товарно-транспортная накладная
//														Для остальных видов документов ФНС не указывается.			
// 
//			Состав следующих полей структуры различен для различных видов документов.
//
//			(необязательный)	Дата			- Дата
//			(необязательный)	Номер			- Строка
//			(необязательный)	СуммаВсего		- Число
//			(необязательный)	СуммаНалога		- Число
//			(необязательный)	НомерОснования	- Строка
//			(необязательный)	ДатаОснования	- Дата
//			(необязательный)	Предмет			- Строка
//			(необязательный)	НачалоПериода	- Дата
//			(необязательный)	КонецПериода	- Дата
//			(необязательный)	Участники		- Массив структур, 
//				поля структуры
//					(необязательный)	Роль				- ПеречислениеСсылка.РолиУчастниковСделкиДокументаПоТребованиюФНС
//					(необязательный)	Контрагент			- СправочникСсылка.Контрагенты
//					(необязательный)	ЯвляетсяЮрЛицом		- Булево
//					(необязательный)	ЮрЛицоНаименование	- Строка
//					(необязательный)	ЮрЛицоИНН			- Строка
//					(необязательный)	ЮрЛицоКПП			- Строка
//					(необязательный)	ФизЛицоИНН			- Строка
//					(необязательный)	ФизЛицоФамилия		- Строка
//					(необязательный)	ФизЛицоИмя			- Строка
//					(необязательный)	ФизЛицоОтчество		- Строка
//
//			Максимально возможный состав полей структуры для различных видов документов:
//				Счет-фактура
//					Дата
//					Номер
//					СуммаВсего
//					СуммаНалога
//					Участники
//				Корректировочный счет-фактура
//					Дата
//					Номер
//					СуммаВсего
//					СуммаНалога
//					НомерОснования
//					ДатаОснования
//					Участники
//				Акт приемки-сдачи работ (услуг)
//					Дата
//					Номер
//					СуммаВсего
//					СуммаНалога
//					НомерОснования
//					ДатаОснования
//					НачалоПериода
//					КонецПериода
//					Участники
//				Товарная накладная (ТОРГ-12)
//					Дата
//					Номер
//					СуммаВсего
//					СуммаНалога
//					НомерОснования
//					ДатаОснования
//					Участники
//				Товарно-транспортная накладная
//					Дата
//					Номер
//					СуммаВсего
//					СуммаНалога
//					НомерОснования
//					ДатаОснования
//					Участники
//				Грузовая таможенная декларация
//					Номер
//					Участники
//				Добавочный лист к грузовой таможенной декларации
//					Номер
//					НомерОснования
//					Участники
//				Договор
//					Дата
//					Номер
//					СуммаВсего
//					СуммаНалога
//					Предмет
//					Участники
//				Дополнение к договору
//					Дата
//					Номер
//					СуммаВсего
//					СуммаНалога
//					Предмет
//					НомерОснования
//					ДатаОснования
//					Участники
//				Спецификация (калькуляция, расчет) цены (стоимости)
//					Дата
//					Номер
//					СуммаВсего
//					СуммаНалога
//					Предмет
//					НомерОснования
//					ДатаОснования
//					Участники
//
//				Роли участников следует выбирать из возможных значений БРО перечисления РолиУчастниковСделкиДокументаПоТребованиюФНС.
//				Общий список возможных значений:
//					Агент
//					Акционер
//					Арендатор
//					Арендодатель
//					Векселедатель
//					Векселеполучатель
//					Генеральный подрядчик
//					Грузоотправитель
//					Грузополучатель
//					Декларант
//					Займодатель
//					Займополучатель (заемщик)
//					Заказчик
//					Импортер
//					Инвестор
//					Исполнитель
//					Лицо, составившее документ 
//					Отправитель
//					Перевозчик
//					Плательщик
//					Поверенный
//					Подрядчик
//					Покупатель
//					Получатель
//					Пользователь
//					Посредник
//					Поставщик
//					Продавец
//					Работник
//					Работодатель
//					Страхователь
//					Страховщик
//					Субподрядчик
//					Участник
//					Учредитель
//					Хранитель
//					Экспедитор
//					Экспортер
//					Эмитент
//
//				Вариант состава ролей участников для различных видов документов:
//					Счет-фактура
//						Агент
//						Грузоотправитель (если приобретаются/реализуются НЕ услуги)
//						Грузополучатель (если приобретаются/реализуются НЕ услуги)
//						Покупатель
//						Продавец
//					Корректировочный счет-фактура
//						Агент
//						Покупатель
//						Продавец
//					Акт приемки-сдачи работ (услуг)
//						Агент
//						Заказчик
//						Исполнитель
//					Товарная накладная (ТОРГ-12)
//						Грузоотправитель
//						Грузополучатель
//						Плательщик
//						Поставщик
//						Экспедитор
//					Товарно-транспортная накладная
//						Грузоотправитель
//						Грузополучатель
//						Заказчик
//						Перевозчик
//						Плательщик
//						Экспедитор
//					Грузовая таможенная декларация
//						Декларант
//						Импортер
//						Экспортер
//						Отправитель
//						Получатель
//					Добавочный лист к грузовой таможенной декларации
//						Декларант
//						Импортер
//						Экспортер
//						Отправитель
//						Получатель
//					Договор
//						Любые значения из общего списка
//					Дополнение к договору
//						Любые значения из общего списка
//					Спецификация (калькуляция, расчет) цены (стоимости)
//						Заказчик
//						Исполнитель
//
Процедура ОпределитьСвойстваИсточниковДляЗаполненияСканированныхДокументовПоТребованиюФНС(СвойстваИсточников) Экспорт
	
КонецПроцедуры

//Формирует сведения о документах-источниках, которые будут отражаться в едином списке документов, представляемых по требованию ФНС. 
//Требуется заполнить для всех объектов метаданных, указанных в определяемом типе ИсточникДокументаПоТребованиюФНСБРО..
//
//Параметры: 
//
//	СвойстваИсточников	- Соответствие, соответствие переданных ссылок на источники и массива структур 
//		Ключ 		– ссылка на источник
//		Значение 	– массив структур (начальное значение: пустой массив)
//		(каждый элемент массива – реквизиты для отображения свойств одного документа в журнале документов, 
//		представляемых по требованию ФНС)
//
//		В общем случае один источник может служить источником для отображения свойств нескольких документов.
//		Если у источника стоит пометка на удаление, массив структур должен остаться пустым массивом.
//		Состав полей структуры различен для различных видов документов-источников.
//
//			Поля структуры:
//				(обязательный)	Организация			- СправочникСсылка.Организации
//				(обязательный)	ВидДокументаФНС		- ПеречислениеСсылка.ВидыПредставляемыхДокументов
//				(необязательный)	Контрагент			- Ссылка на справочник контрагентов
//				(необязательный)	НомерСтрокиИсточника	- Число, обязательно указывается, 
//											если данный источник может служить 
//											источником для заполнения реквизитов 
//											нескольких документов одного вида ФНС 
//											(например Оказание услуг в БПКОРП3) 
//											Для остальных видов документов-источников не указывается.			
//				(необязательный)	Направление 			- Перечисление.
//												НаправленияДокументаПоТребованиюФНС,
//											обязателен для следующих видов документов ФНС:
//												Счет-фактура
//												Корректировочный счет-фактура
//												Акт приемки-сдачи работ (услуг)
//												Товарная накладная (ТОРГ-12)
//												Товарно-транспортная накладная
//												Для остальных видов документов ФНС не указывается.			
//
//			Состав следующих полей структуры различен для различных видов документов ФНС.
//
//				(необязательный)	Дата					- Дата
//				(необязательный)	Номер					- Строка
//				(необязательный)	СуммаВсего				- Число
//
//			Максимально возможный состав полей структуры для различных видов документов ФНС:
//				Счет-фактура
//					Дата
//					Номер
//					СуммаВсего
//				Корректировочный счет-фактура
//					Дата
//					Номер
//					СуммаВсего
//				Акт приемки-сдачи работ (услуг)
//					Дата
//					Номер
//					СуммаВсего
//				Товарная накладная (ТОРГ-12)
//					Дата
//					Номер
//					СуммаВсего
//				Товарно-транспортная накладная
//					Дата
//					Номер
//					СуммаВсего
//				Грузовая таможенная декларация
//					Номер
//				Добавочный лист к грузовой таможенной декларации
//					Номер
//				Договор
//					Дата
//					Номер
//					СуммаВсего
//				Дополнение к договору
//					Дата
//					Номер
//					СуммаВсего
//				Спецификация (калькуляция, расчет) цены (стоимости)
//					Дата
//					Номер
//					СуммаВсего
//
Процедура ОпределитьСвойстваИсточниковДляРегистраДокументыПоТребованиюФНС(СвойстваИсточников) Экспорт
	
КонецПроцедуры

//Определяет владельца электронного документа
//
//Параметры: 
//	ЭД - ссылка на справочник электронных документов
//	ВладелецЭД - ссылка на владельца электронного документа
//
// Пример:
// ЭлектронныеДокументы.ОпределитьВладельцаЭлектронногоДокумента(ЭД, ВладелецЭД)
//
Процедура ОпределитьВладельцаЭлектронногоДокумента(ЭД, ВладелецЭД) Экспорт

КонецПроцедуры

//Заполняет вид документа ФНС для владельцев электронных документов, которые будут отражаться в едином списке документов, представляемых по требованию ФНС. 
//Для владельца ЭД должны существовать электронные документы по завершенным обменам, не помеченые на удаление и принадлежащие следующим видам ЭД:
//СчетФактура
//КорректировочныйСчетФактура
//ТОРГ12Продавец
//ТОРГ12Покупатель
//АктИсполнитель
//АктЗаказчик
//
//Параметры: 
//
//	СвойстваВладельцевЭД	- Соответствие 
//		Ключ 		– ссылка на владельца электронного документа
//		Значение 	– Строка. Вид электронного документа, который следует преобразовать 
//		к строковому представлению определенного формата. Возможные значения:
//			"АктПриемкиСдачиРабот"
//			"СчетФактура"
//			"КорректировочныйСчетФактура"
//  		"ТоварнаяНакладнаяТОРГ12"
//
//	МассивВладельцевЭД	- (необязательный) Массив, массив ссылок на владельцев электронные документы. 
//		Если параметр указан, требуется заполнить свойства владельцев ЭД из массива. 
//		Если массив пустой, тогда требуется заполнить свойства для всех владельцев ЭД, удовлетворяющих свойствам, указанным выше.
//
// Пример:
// ЭлектронныеДокументы.ОпределитьСвойстваВладельцевЭлектронныхДокументов(СвойстваВладельцевЭД, МассивВладельцевЭД)
//
Процедура ОпределитьСвойстваВладельцевЭлектронныхДокументов(СвойстваВладельцевЭД, МассивВладельцевЭД = Неопределено) Экспорт
	
КонецПроцедуры

// Переопределяет строку, в которой перечислены направления, внешние сервисы которых следует разместить на закладке "Личные кабинеты".
// Перечисление производится через запятую без пробелов.
//
// Параметры:
//  СтрокаСписокПоддерживаемыхКО	- Строка
//
// Пример по установке полного списка возможных значений (одновременно значение по умолчанию):
//  СтрокаСписокПоддерживаемыхКО = "ФНСЮЛ,ФНСИП,ПФР,ФСС,ФСРАР,РПН";
//
// Если значение по умолчанию устраивает, заполнять не требуется.
//
Процедура ПереопределитьСписокПоддерживаемыхНаправлений(СтрокаСписокПоддерживаемыхКО) Экспорт
	СтрокаСписокПоддерживаемыхКО = "ФНСЮЛ,ФНСИП,ПФР,ФСС";
КонецПроцедуры

#КонецОбласти

#Область ПоясненияКДекларацииПоНДС

// Ищет ссылку на счет-фактуру по переданным реквизитам.
//  Если счет-фактура найден, возвращается ссылка на него в параметре НайденныйСчетФактура
//
// Параметры:
//  ПараметрыПоиска	- Структура - содержит параметры для поиска счета-фактуры
//    * НомерСчетаФактуры                             - строка
//    * ДатаСчетаФактуры                              - дата
//    * НомерИсправленияСчетаФактуры                  - число
//    * ДатаИсправленияСчетаФактуры                   - дата
//    * НомерКорректировочногоСчетаФактуры            - строка 
//    * ДатаКорректировочногоСчетаФактуры             - дата
//    * НомерИсправленияКорректировочногоСчетаФактуры - число
//    * ДатаИсправленияКорректировочногоСчетаФактуры  - дата
//    * ИННКонтрагента - строка
//    * Организация - СправочникСсылка.Организации
//    * СчетФактураВыданный - Булево - "Истина" при проверке разделов 9, 9.1, 10 (кроме графы с реквизитами счета-фактуры продавца), 12
//  ПоискВыполнен - Булево - флаг, что в конфигурации есть счета-фактуры и поиск выполнен.
//  НайденныйСчетФактура - ссылка на найденный счет-фактуру
Процедура НайтиСчетФактуруПоРеквизитам(ПараметрыПоиска, ПоискВыполнен, НайденныйСчетФактура) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область МакетыПенсионныхДел

// Функция возвращает сведения о физлице.
//
// Параметры:
//  Сотрудник         - ссылка на элемент справочника см. тип ОпределяемыйТип.СотрудникМакетПенсионногоДела;
//  ДатаЗначения      - дата, на которую нужно получить сведения;
//  МассивПоказателей - массив показателей, значения которых нужно вернуть.
//  
// Возвращаемое значение:
//  Структура с ключами из массива показателей и возвращаемыми значениями.
//
// Пример:
//	Если МассивПоказателей = Неопределено Тогда
//		МассивПоказателей = Новый Массив;
//		МассивПоказателей.Добавить("СНИЛС");
//		МассивПоказателей.Добавить("Фамилия");
//		МассивПоказателей.Добавить("Имя");
//		МассивПоказателей.Добавить("Отчество");
//      МассивПоказателей.Добавить("АдресРегистрации");
//      МассивПоказателей.Добавить("Телефон");
//	КонецЕсли;
//	ФЛСведения = Новый Структура;
//	Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
//		Если ИмяПоказателя = "ИНН" Тогда
//			Значение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ФизЛицо, "ИНН");
//		ИначеЕсли ИмяПоказателя = "Фамилия"
//			  ИЛИ ИмяПоказателя = "Имя"
//			  ИЛИ ИмяПоказателя = "Отчество" Тогда
//			ТаблицаСрезПоследних = РегистрыСведений.ФИОФизическихЛиц.СрезПоследних(ДатаЗначения, Новый Структура("ФизическоеЛицо", ФизЛицо));
//			Если ТаблицаСрезПоследних.Количество() > 0 Тогда
//				Значение = ТаблицаСрезПоследних[0][ИмяПоказателя];
//			Иначе
//				Значение = "";
//			КонецЕсли;
//		Иначе
//			Значение = "";
//		КонецЕсли;
//		ФЛСведения.Вставить(ИмяПоказателя, Значение);
//	КонецЦикла;
//	Возврат ФЛСведения;
//
Функция ПолучитьСведенияОСотруднике(Знач Сотрудник, Знач МассивПоказателей = Неопределено, Знач ДатаЗначения = Неопределено) Экспорт
	
	СведенияОСотруднике = Новый Структура("Фамилия, Имя, Отчество, СтраховойНомерПФР,СНИЛС,   АдресРегистрации, Телефон");
	ФизЛицо = Сотрудник.ФизЛицо;
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ФИОФизическихЛицСрезПоследних.Фамилия,
	|	ФИОФизическихЛицСрезПоследних.Имя,
	|	ФИОФизическихЛицСрезПоследних.Отчество,
	|	ФИОФизическихЛицСрезПоследних.ФизЛицо.СтраховойНомерПФР КАК СтраховойНомерПФР,
	|	КонтактнаяИнформацияАдрес.Представление КАК Адрес,
	|	КонтактнаяИнформацияТелефон.Представление КАК Телефон
	|ИЗ
	|	РегистрСведений.ФИОФизЛиц.СрезПоследних КАК ФИОФизическихЛицСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица.КонтактнаяИнформация КАК КонтактнаяИнформацияАдрес
	|		ПО (КонтактнаяИнформацияАдрес.Ссылка = &ФизическоеЛицо)
	|			И (КонтактнаяИнформацияАдрес.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.АдресФизЛицаПоПрописке))
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица.КонтактнаяИнформация КАК КонтактнаяИнформацияТелефон
	|		ПО (КонтактнаяИнформацияТелефон.Ссылка = &ФизическоеЛицо)
	|			И (КонтактнаяИнформацияТелефон.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонФизЛица))
	|ГДЕ
	|	ФИОФизическихЛицСрезПоследних.ФизЛицо = &ФизическоеЛицо";
	
	Запрос.УстановитьПараметр("ФизическоеЛицо", ФизЛицо);
	
	Попытка
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		Если Выборка.Следующий() Тогда
			СведенияОСотруднике.Вставить("Фамилия",	Выборка.Фамилия);
			СведенияОСотруднике.Вставить("Имя",		Выборка.Имя);
			СведенияОСотруднике.Вставить("Отчество",	Выборка.Отчество);
			СведенияОСотруднике.Вставить("СНИЛС", Выборка.СтраховойНомерПФР);
			СведенияОСотруднике.Вставить("АдресРегистрации", Выборка.Адрес);
			СведенияОСотруднике.Вставить("Телефон", Выборка.Телефон);
		КонецЕсли;
	Исключение
	КонецПопытки;
	
	Возврат СведенияОСотруднике;
	
КонецФункции

#КонецОбласти