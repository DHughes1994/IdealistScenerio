import LightningDatatable from "lightning/datatable";
import richTextColumnType from "./richTextColumnType.html";

export default class CustomDatatable extends LightningDatatable {
    static customTypes={
        richText: {
            template: richTextColumnType,
            standardCellLayout: true
        }
    }
}